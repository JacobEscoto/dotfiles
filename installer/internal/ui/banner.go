package ui

import (
	"fmt"
	"strings"

	"github.com/JacobEscoto/dotfiles/installer/internal/system"
	"github.com/charmbracelet/lipgloss"
)

// RenderBanner renders and colorizes the system info for prettier UI.
func RenderBanner(info system.SystemInfo, networkStatus string) string {
	headerTitle := `
               ██╗ █████╗  ██████╗ ██████╗ ██████╗ 
               ██║██╔══██╗██╔════╝██╔═══██╗██╔══██╗
               ██║███████║██║     ██║   ██║██████╔╝
          ██   ██║██╔══██║██║     ██║   ██║██╔══██╗
          ╚█████╔╝██║  ██║╚██████╗╚██████╔╝██████╔╝
           ╚════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚═════╝ 
                                         
██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗
██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝
██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗
██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║
██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║
╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝`

	titleStyle := lipgloss.NewStyle().
		Bold(true).
		Foreground(lipgloss.Color("#ADFFED"))

	textStyle := lipgloss.NewStyle().
		Foreground(lipgloss.Color("#E6E6E6"))

	tagStyle := lipgloss.NewStyle().
		Foreground(lipgloss.Color("#D0B3F5")).
		Bold(true)

	boxStyle := lipgloss.NewStyle().
		Width(65).
		Align(lipgloss.Center).
		Padding(2, 0)

	nameOS := info.OSName
	if nameOS == "" {
		nameOS = info.OS
	}
	if info.IsWSL {
		nameOS += " (WSL)"
	}

	tags := []string{nameOS}
	if info.HasBrew {
		tags = append(tags, "brew")
	}
	if info.UserShell != "" {
		tags = append(tags, info.UserShell)
	}

	firstLine := textStyle.Render(strings.Join(tags, " | "))
	secondLine := fmt.Sprintf("%s %s", tagStyle.Render("Network Status:"), tagStyle.Render(networkStatus))

	header := titleStyle.Render(headerTitle)
	body := lipgloss.JoinVertical(lipgloss.Center, firstLine, secondLine)

	content := lipgloss.JoinVertical(lipgloss.Center, header, "", body)

	return boxStyle.Render(content)
}
