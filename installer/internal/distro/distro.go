package distro

import (
	"bufio"
	"fmt"
	"os"
	"runtime"
	"strings"
)

// DistroInfo represents the details of the Linux distribution.
type DistroInfo struct {
	Name    string
	ID      string
	Version string
}

// GetLinuxDistro collect the data of Name, ID, and Version from any Linux distribution.
func GetLinuxDistro() (DistroInfo, error) {
	var distroInfo DistroInfo

	if runtime.GOOS != "linux" {
		return distroInfo, fmt.Errorf("not a Linux system")
	}

	file, err := os.Open("/etc/os-release")
	if err != nil {
		file, err = os.Open("/usr/lib/os-release")
		if err != nil {
			return distroInfo, fmt.Errorf("failed top open os-release file: %w", err)
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

		value := strings.Trim(parts[1], `"`)

		switch key {
		case "NAME":
			distroInfo.Name = value
		case "ID":
			distroInfo.ID = value
		case "VERSION_ID":
			distroInfo.Version = value
		}
	}

	return distroInfo, scanner.Err()
}
