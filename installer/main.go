package main

import (
	"fmt"
	"os"

	"github.com/JacobEscoto/dotfiles/installer/internal/system"
	"github.com/JacobEscoto/dotfiles/installer/internal/ui"
)

func main() {
	info, err := system.DetectSystemInfo()
	if err != nil {
		os.Exit(1)
	}

	networkStatus := system.GetNetworkStatus()
	banner := ui.RenderBanner(info, string(networkStatus))
	fmt.Println(banner)
}
