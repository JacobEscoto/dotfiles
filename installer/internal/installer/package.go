package installer

import (
	"bytes"
	"fmt"
	"os/exec"
	"strings"

	"dotfiles-installer/internal/config"
)

type PackageSummary struct {
	Manager   string
	Attempted int
	Installed int
	Skipped   int
	Error     string
}

// FindMissingAptPackages checks which configured APT packages need installation
func FindMissingAptPackages() (missing []string, totalChecked int) {
	items := config.GetAptPackages()
	totalChecked = len(items)

	for _, item := range items {
		// If binary check succeeds, tool is already installed
		if item.Binary != "" {
			if _, err := exec.LookPath(item.Binary); err == nil {
				continue
			}
		}
		// If no binary specified or binary not found, collect packages
		missing = append(missing, item.AptPackages...)
	}

	missing = uniqueStrings(missing)
	return missing, totalChecked
}

// InstallAptPackages runs apt-get update and apt-get install in batch
func InstallAptPackages(packages []string, dryRun bool) PackageSummary {
	summary := PackageSummary{Manager: "apt", Attempted: len(packages)}
	if len(packages) == 0 {
		return summary
	}

	if dryRun {
		summary.Installed = len(packages)
		return summary
	}

	// apt update
	updateCmd := exec.Command("sudo", "apt-get", "update", "-y")
	var updateErr bytes.Buffer
	updateCmd.Stderr = &updateErr
	if err := updateCmd.Run(); err != nil {
		summary.Error = fmt.Sprintf("apt-get update failed: %s (%v)", strings.TrimSpace(updateErr.String()), err)
		return summary
	}

	// batch install
	args := append([]string{"apt-get", "install", "-y"}, packages...)
	installCmd := exec.Command("sudo", args...)
	var installErr bytes.Buffer
	installCmd.Stderr = &installErr
	if err := installCmd.Run(); err != nil {
		summary.Error = fmt.Sprintf("apt-get install failed: %s (%v)", strings.TrimSpace(installErr.String()), err)
		return summary
	}

	summary.Installed = len(packages)
	return summary
}

// FindMissingBrewPackages checks which Brew formula packages need installation
func FindMissingBrewPackages() (missing []string, totalChecked int) {
	items := config.GetBrewPackages()
	totalChecked = len(items)

	// If brew itself is not found, return empty
	if _, err := exec.LookPath("brew"); err != nil {
		return nil, 0
	}

	for _, item := range items {
		if item.Binary != "" {
			if _, err := exec.LookPath(item.Binary); err == nil {
				continue
			}
		}
		if item.BrewFormula != "" {
			missing = append(missing, item.BrewFormula)
		}
	}

	missing = uniqueStrings(missing)
	return missing, totalChecked
}

// InstallBrewPackages runs brew install in batch
func InstallBrewPackages(formulas []string, dryRun bool) PackageSummary {
	summary := PackageSummary{Manager: "brew", Attempted: len(formulas)}
	if len(formulas) == 0 {
		return summary
	}

	if dryRun {
		summary.Installed = len(formulas)
		return summary
	}

	args := append([]string{"install"}, formulas...)
	cmd := exec.Command("brew", args...)
	var stderr bytes.Buffer
	cmd.Stderr = &stderr
	if err := cmd.Run(); err != nil {
		summary.Error = fmt.Sprintf("brew install failed: %s (%v)", strings.TrimSpace(stderr.String()), err)
		return summary
	}

	summary.Installed = len(formulas)
	return summary
}

func uniqueStrings(slice []string) []string {
	seen := make(map[string]bool)
	var result []string
	for _, s := range slice {
		if !seen[s] && s != "" {
			seen[s] = true
			result = append(result, s)
		}
	}
	return result
}
