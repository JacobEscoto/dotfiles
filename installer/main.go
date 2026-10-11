package main

import (
	"flag"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"time"

	"dotfiles-installer/internal/installer"
	"dotfiles-installer/internal/ui"
)

func main() {
	symlinksOnly := flag.Bool("symlinks-only", false, "Configure symlinks only (skip package installations)")
	packagesOnly := flag.Bool("packages-only", false, "Install packages only (skip symlink setup)")
	noBackup := flag.Bool("no-backup", false, "Disable backing up existing configs when overwriting")
	dryRun := flag.Bool("dry-run", false, "Simulate operations without making changes")
	verbose := flag.Bool("v", false, "Enable verbose output")
	dotfilesDirFlag := flag.String("dotfiles-dir", "", "Path to dotfiles directory")
	homeDirFlag := flag.String("home-dir", "", "Path to target home directory")

	flag.Usage = func() {
		fmt.Printf("Dotfiles Automated Installer\n\n")
		fmt.Printf("Usage: ./installer [flags]\n\n")
		fmt.Printf("Flags:\n")
		flag.PrintDefaults()
	}

	flag.Parse()

	startTime := time.Now()

	// 1. Resolve Home Directory
	homeDir := *homeDirFlag
	if homeDir == "" {
		var err error
		homeDir, err = os.UserHomeDir()
		if err != nil {
			ui.Error(fmt.Sprintf("Failed to resolve user home directory: %v", err))
			os.Exit(1)
		}
	}

	// 2. Resolve Dotfiles Directory
	dotfilesDir := *dotfilesDirFlag
	if dotfilesDir == "" {
		dotfilesDir = detectDotfilesDir(homeDir)
	}

	if *dryRun {
		ui.Warn("Dry-run mode active. No changes will be made to your system.")
	}

	// Step 1: Symlinks
	if !*packagesOnly {
		sp := ui.NewSpinner("Linking configuration files...")
		sp.Start()

		symSummary := installer.LinkAll(installer.SymlinkOptions{
			DotfilesDir: dotfilesDir,
			HomeDir:     homeDir,
			Backup:      !*noBackup,
			DryRun:      *dryRun,
			Verbose:     *verbose,
		})

		if symSummary.Failed > 0 {
			sp.Fail(fmt.Sprintf("Dotfiles symlinking finished with %d errors (%d linked, %d skipped)",
				symSummary.Failed, symSummary.Linked, symSummary.Skipped))
			for _, errMsg := range symSummary.Errors {
				fmt.Printf("   %s %s\n", ui.Red("->"), errMsg)
			}
		} else {
			sp.Success(fmt.Sprintf("Dotfiles symlinked (%d linked, %d skipped)",
				symSummary.Linked, symSummary.Skipped))
		}
	}

	// Step 2: System Packages (APT)
	if !*symlinksOnly {
		sp := ui.NewSpinner("Checking system packages (apt)...")
		sp.Start()

		missingApt, _ := installer.FindMissingAptPackages()
		if len(missingApt) == 0 {
			sp.Success("System packages (apt) already up to date")
		} else {
			sp.UpdateMessage(fmt.Sprintf("Installing %d missing apt package(s)...", len(missingApt)))
			res := installer.InstallAptPackages(missingApt, *dryRun)
			if res.Error != "" {
				sp.Fail(fmt.Sprintf("APT installation error: %s", res.Error))
			} else {
				sp.Success(fmt.Sprintf("Installed %d system package(s) via apt", res.Installed))
			}
		}
	}

	// Step 3: Brew Packages
	if !*symlinksOnly {
		if _, err := exec.LookPath("brew"); err == nil {
			sp := ui.NewSpinner("Checking Homebrew packages (brew)...")
			sp.Start()

			missingBrew, _ := installer.FindMissingBrewPackages()
			if len(missingBrew) == 0 {
				sp.Success("Homebrew packages already up to date")
			} else {
				sp.UpdateMessage(fmt.Sprintf("Installing %d missing brew formula(s)...", len(missingBrew)))
				res := installer.InstallBrewPackages(missingBrew, *dryRun)
				if res.Error != "" {
					sp.Fail(fmt.Sprintf("Brew installation error: %s", res.Error))
				} else {
					sp.Success(fmt.Sprintf("Installed %d package(s) via brew", res.Installed))
				}
			}
		} else if *verbose {
			ui.Info("Homebrew not detected on PATH, skipping brew formula installation")
		}
	}

	elapsed := time.Since(startTime).Round(100 * time.Millisecond)
	fmt.Println()
	ui.Success(fmt.Sprintf("Dotfiles setup completed in %s", elapsed))
}

func detectDotfilesDir(homeDir string) string {
	// Try current working dir
	cwd, err := os.Getwd()
	if err == nil {
		if isDotfilesDir(cwd) {
			return cwd
		}
		parent := filepath.Dir(cwd)
		if isDotfilesDir(parent) {
			return parent
		}
	}

	// Try default home dotfiles
	defaultHome := filepath.Join(homeDir, "dotfiles")
	if isDotfilesDir(defaultHome) {
		return defaultHome
	}

	return cwd
}

func isDotfilesDir(dir string) bool {
	checks := []string{
		filepath.Join(dir, "i3"),
		filepath.Join(dir, "polybar"),
		filepath.Join(dir, "rofi"),
		filepath.Join(dir, "kitty"),
	}
	found := 0
	for _, c := range checks {
		if _, err := os.Stat(c); err == nil {
			found++
		}
	}
	return found >= 2
}
