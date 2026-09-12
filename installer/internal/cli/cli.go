package cli

import (
	"fmt"

	"dotfiles-installer/internal/config"
	"dotfiles-installer/internal/installer"
	"dotfiles-installer/internal/tui"
)

type CLIOptions struct {
	DotfilesDir  string
	HomeDir      string
	Backup       bool
	DryRun       bool
	SymlinksOnly bool
	PackagesOnly bool
}

func RunNonInteractive(opts CLIOptions) int {
	fmt.Println(tui.RenderBanner(false))
	fmt.Println("\n=== [NON-INTERACTIVE INSTALLATION MODE] ===")

	sysInfo := installer.DetectSystemInfo(opts.DotfilesDir, opts.HomeDir)

	fmt.Printf("Source Dotfiles Directory: %s\n", sysInfo.DotfilesDir)
	fmt.Printf("Target Home Directory:     %s\n", sysInfo.HomeDir)
	fmt.Printf("Package Manager:           %s\n", sysInfo.PackageManager)
	fmt.Printf("Backup Mode:               %v\n", opts.Backup)
	fmt.Printf("Dry Run Mode:              %v\n\n", opts.DryRun)

	inst := installer.NewInstaller(installer.InstallerOptions{
		DotfilesDir: opts.DotfilesDir,
		HomeDir:     opts.HomeDir,
		Backup:      opts.Backup,
		DryRun:      opts.DryRun,
	})

	var results []installer.Result

	// Symlinks
	if !opts.PackagesOnly {
		fmt.Println("--- Symlinking Dotfiles Configurations ---")
		symlinks := config.GetDefaultSymlinks()
		for _, sym := range symlinks {
			res := inst.InstallSymlink(sym)
			results = append(results, res)
			printResultCLI(res)
		}
		fmt.Println()
	}

	// Packages
	if !opts.SymlinksOnly {
		fmt.Println("--- Installing Applications & Packages ---")
		packages := config.GetDefaultPackages()
		var aptUpdated bool
		for _, pkg := range packages {
			res := inst.InstallPackage(pkg, &aptUpdated)
			results = append(results, res)
			printResultCLI(res)
		}
		fmt.Println()
	}

	// Summary
	fmt.Println("=== Installation Summary ===")
	succCount, skipCount, failCount := 0, 0, 0
	for _, r := range results {
		switch r.Status {
		case installer.StatusSuccess:
			succCount++
		case installer.StatusSkipped:
			skipCount++
		case installer.StatusFailed:
			failCount++
		}
	}

	fmt.Printf("Success: %d  |  Skipped: %d  |  Failed: %d\n", succCount, skipCount, failCount)
	if failCount > 0 {
		fmt.Println("Installation finished with errors.")
		return 1
	}

	fmt.Println("Installation completed successfully!")
	return 0
}

func printResultCLI(res installer.Result) {
	tag := "[ OK ]"
	switch res.Status {
	case installer.StatusSkipped:
		tag = "[SKIP]"
	case installer.StatusFailed:
		tag = "[FAIL]"
	}

	fmt.Printf("%s %-25s: %s\n", tag, res.Name, res.Message)
}
