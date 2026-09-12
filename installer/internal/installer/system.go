package installer

import (
	"os/exec"
	"runtime"
	"strings"
)

type SystemInfo struct {
	OS             string
	PackageManager string
	HasSudo        bool
	DotfilesDir    string
	HomeDir        string
}

func DetectSystemInfo(dotfilesDir string, homeDir string) SystemInfo {
	info := SystemInfo{
		OS:          runtime.GOOS,
		DotfilesDir: dotfilesDir,
		HomeDir:     homeDir,
	}

	if info.OS == "linux" {
		if _, err := exec.LookPath("apt-get"); err == nil {
			info.PackageManager = "apt"
		} else if _, err := exec.LookPath("pacman"); err == nil {
			info.PackageManager = "pacman"
		} else if _, err := exec.LookPath("dnf"); err == nil {
			info.PackageManager = "dnf"
		}
	} else if info.OS == "darwin" {
		if _, err := exec.LookPath("brew"); err == nil {
			info.PackageManager = "brew"
		}
	}

	if _, err := exec.LookPath("sudo"); err == nil {
		info.HasSudo = true
	}

	return info
}

func IsBinaryInstalled(binary string) bool {
	if binary == "" {
		return false
	}
	_, err := exec.LookPath(binary)
	return err == nil
}

func IsAptPackageInstalled(pkg string) bool {
	cmd := exec.Command("dpkg", "-s", pkg)
	out, err := cmd.CombinedOutput()
	if err != nil {
		return false
	}
	return strings.Contains(string(out), "Status: install ok installed")
}
