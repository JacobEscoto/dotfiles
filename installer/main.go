package main

import (
	"flag"
	"fmt"
	"os"
	"path/filepath"

	tea "github.com/charmbracelet/bubbletea"

	"dotfiles-installer/internal/cli"
	"dotfiles-installer/internal/tui"
)

func main() {
	nonInteractive := flag.Bool("non-interactive", false, "Run installer in non-interactive CLI mode")
	flag.BoolVar(nonInteractive, "n", false, "Alias for --non-interactive")
	flag.BoolVar(nonInteractive, "y", false, "Alias for --non-interactive")
	flag.BoolVar(nonInteractive, "yes", false, "Alias for --non-interactive")

	symlinksOnly := flag.Bool("symlinks-only", false, "Install symlinks only")
	packagesOnly := flag.Bool("packages-only", false, "Install packages only")
	noBackup := flag.Bool("no-backup", false, "Disable backing up existing config files")
	dryRun := flag.Bool("dry-run", false, "Simulate installation without making changes")
	dotfilesDirFlag := flag.String("dotfiles-dir", "", "Path to dotfiles directory")
	homeDirFlag := flag.String("home-dir", "", "Path to target home directory")

	flag.Usage = func() {
		fmt.Printf("Jacob's Dotfiles Installer\n\n")
		fmt.Printf("Usage:\n")
		fmt.Printf("  ./installer [flags]\n\n")
		fmt.Printf("Flags:\n")
		flag.PrintDefaults()
	}

	flag.Parse()

	// Determine Home Directory
	homeDir := *homeDirFlag
	if homeDir == "" {
		var err error
		homeDir, err = os.UserHomeDir()
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error detecting home directory: %v\n", err)
			os.Exit(1)
		}
	}

	// Determine Dotfiles Directory
	dotfilesDir := *dotfilesDirFlag
	if dotfilesDir == "" {
		// Attempt auto-detection
		exePath, err := os.Executable()
		if err == nil {
			parentDir := filepath.Dir(filepath.Dir(exePath))
			if isDotfilesDir(parentDir) {
				dotfilesDir = parentDir
			}
		}

		if dotfilesDir == "" {
			cwd, err := os.Getwd()
			if err == nil {
				if isDotfilesDir(cwd) {
					dotfilesDir = cwd
				} else {
					parentCwd := filepath.Dir(cwd)
					if isDotfilesDir(parentCwd) {
						dotfilesDir = parentCwd
					}
				}
			}
		}

		if dotfilesDir == "" {
			defaultHomeDotfiles := filepath.Join(homeDir, "dotfiles")
			if isDotfilesDir(defaultHomeDotfiles) {
				dotfilesDir = defaultHomeDotfiles
			} else {
				// Fallback to parent of current folder
				dotfilesDir, _ = filepath.Abs("..")
			}
		}
	}

	backup := !*noBackup

	if *nonInteractive {
		exitCode := cli.RunNonInteractive(cli.CLIOptions{
			DotfilesDir:  dotfilesDir,
			HomeDir:      homeDir,
			Backup:       backup,
			DryRun:       *dryRun,
			SymlinksOnly: *symlinksOnly,
			PackagesOnly: *packagesOnly,
		})
		os.Exit(exitCode)
	}

	// Run Interactive TUI Mode
	p := tea.NewProgram(
		tui.NewModel(dotfilesDir, homeDir),
		tea.WithAltScreen(),
	)

	if _, err := p.Run(); err != nil {
		fmt.Fprintf(os.Stderr, "Error running TUI installer: %v\n", err)
		os.Exit(1)
	}
}

func isDotfilesDir(path string) bool {
	if _, err := os.Stat(filepath.Join(path, "fish")); err == nil {
		return true
	}
	if _, err := os.Stat(filepath.Join(path, "README.md")); err == nil {
		return true
	}
	return false
}
