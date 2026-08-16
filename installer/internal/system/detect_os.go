package system

import (
	"bufio"
	"fmt"
	"os"
	"path/filepath"
	"runtime"
	"strings"
)

// SystemInfo saves the details of the operating system.
type SystemInfo struct {
	OS        string
	OSName    string
	ID        string
	Version   string
	IsWSL     bool
	UserShell string
}

// DetectSystemInfo searchs for the OS name.
func DetectSystemInfo() (SystemInfo, error) {
	info := SystemInfo{
		OS:        "unknown",
		UserShell: getUserShell(),
	}

	switch runtime.GOOS {
	case "linux":
		info.OS = "Linux"
		distroName, distroID, distroVersion, err := getLinuxDistro()
		if err != nil {
			return info, err
		}
		info.OSName = distroName
		info.ID = distroID
		info.Version = distroVersion
		info.IsWSL = checkWSL()
	case "darwin":
		info.OS = "macOS"
		info.OSName = "macOS"
		info.ID = "darwin"
	}

	return info, nil
}

func getLinuxDistro() (string, string, string, error) {
	var name, id, version string

	file, err := os.Open("/etc/os-release")
	if err != nil {
		file, err = os.Open("/usr/lib/os-release")
		if err != nil {
			return "", "", "", fmt.Errorf("failed to open os-release file: %w", err)
		}
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := scanner.Text()
		if !strings.Contains(line, "=") {
			continue
		}

		parts := strings.SplitN(line, "=", 2)
		key := parts[0]

		value := strings.Trim(parts[1], "\"' \t")

		switch key {
		case "NAME":
			name = value

		case "ID":
			id = value
		case "VERSION_ID":
			version = value
		}
	}

	return name, id, version, scanner.Err()
}

func checkWSL() bool {
	data, err := os.ReadFile("/proc/version")
	if err != nil {
		return false
	}
	content := strings.ToLower(string(data))
	return strings.Contains(content, "microsoft") || strings.Contains(content, "wsl")
}

func getUserShell() string {
	shell := os.Getenv("SHELL")
	if shell == "" {
		return "unknown"
	}
	return filepath.Base(shell)
}
