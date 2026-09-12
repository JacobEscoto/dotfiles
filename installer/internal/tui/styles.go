package tui

import (
	"fmt"
	"strings"

	"github.com/charmbracelet/lipgloss"
)

var (
	// Lightblue Accent Colors
	AccentColor     = lipgloss.Color("#5FD7FF") // Bright Light Blue
	AccentColorDim  = lipgloss.Color("#38A1F3") // Medium Light Blue
	AccentColorDark = lipgloss.Color("#0087D7") // Deep Light Blue
	SubtleColor     = lipgloss.Color("#6272A4") // Muted Blue Gray
	SuccessColor    = lipgloss.Color("#50FA7B") // Green
	WarningColor    = lipgloss.Color("#F1FA8C") // Yellow
	ErrorColor      = lipgloss.Color("#FF5555") // Red
	BgDark          = lipgloss.Color("#1E1E2E")

	// Text Styles
	TitleStyle = lipgloss.NewStyle().
			Bold(true).
			Foreground(AccentColor).
			MarginLeft(1)

	SubtitleStyle = lipgloss.NewStyle().
			Foreground(SubtleColor).
			Italic(true)

	HeaderStyle = lipgloss.NewStyle().
			Bold(true).
			Foreground(lipgloss.Color("#FFFFFF")).
			Background(AccentColorDark).
			Padding(0, 1)

	StepBadgeStyle = lipgloss.NewStyle().
			Bold(true).
			Foreground(lipgloss.Color("#000000")).
			Background(AccentColor).
			Padding(0, 1)

	SelectedStyle = lipgloss.NewStyle().
			Bold(true).
			Foreground(AccentColor).
			PaddingLeft(1)

	UnselectedStyle = lipgloss.NewStyle().
			Foreground(lipgloss.Color("#DDDDDD")).
			PaddingLeft(1)

	DescStyle = lipgloss.NewStyle().
			Foreground(SubtleColor).
			PaddingLeft(4)

	BoxStyle = lipgloss.NewStyle().
			Border(lipgloss.RoundedBorder()).
			BorderForeground(AccentColorDim).
			Padding(1, 2)

	CompactBoxStyle = lipgloss.NewStyle().
			Border(lipgloss.RoundedBorder()).
			BorderForeground(AccentColorDim).
			Padding(0, 1)

	KeyStyle = lipgloss.NewStyle().
			Bold(true).
			Foreground(AccentColor)

	HelpStyle = lipgloss.NewStyle().
			Foreground(SubtleColor).
			Padding(1, 0)

	AccentStyle = lipgloss.NewStyle().
			Foreground(AccentColor)

	AccentDimStyle = lipgloss.NewStyle().
			Foreground(AccentColorDim)

	BadgeSuccess = lipgloss.NewStyle().
			Bold(true).
			Foreground(lipgloss.Color("#000000")).
			Background(SuccessColor).
			Padding(0, 1)

	BadgeSkipped = lipgloss.NewStyle().
			Bold(true).
			Foreground(lipgloss.Color("#000000")).
			Background(WarningColor).
			Padding(0, 1)

	BadgeFailed = lipgloss.NewStyle().
			Bold(true).
			Foreground(lipgloss.Color("#FFFFFF")).
			Background(ErrorColor).
			Padding(0, 1)
)

const AnsiShadowTitle = `
     ██╗ █████╗  ██████╗ ██████╗ ██████╗ ███████╗    ██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗
     ██║██╔══██╗██╔════╝██╔═══██╗██╔══██╗██╔════╝    ██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝
     ██║███████║██║     ██║   ██║██████╔╝███████╗    ██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗
██   ██║██╔══██║██║     ██║   ██║██╔══██╗╚════██║    ██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║
╚█████╔╝██║  ██║╚██████╗╚██████╔╝██████╔╝███████║    ██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║
 ╚════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝    ╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝`

func RenderBanner(compact bool) string {
	titleStyle := lipgloss.NewStyle().Bold(true).Foreground(AccentColor)
	subStyle := lipgloss.NewStyle().Foreground(SubtleColor).Italic(true)

	if compact {
		titleLines := strings.Split(strings.TrimSpace(AnsiShadowTitle), "\n")
		var sb strings.Builder
		for _, line := range titleLines {
			sb.WriteString(titleStyle.Render(line) + "\n")
		}
		return sb.String()
	}

	titleRendered := titleStyle.Render(strings.TrimPrefix(AnsiShadowTitle, "\n"))

	banner := lipgloss.JoinVertical(
		lipgloss.Center,
		titleRendered,
		subStyle.Render("── Dotfiles & System Environment Installer for Debian GNU/Linux ──"),
	)

	return banner
}

func RenderHelpBar(keys [][2]string) string {
	var parts []string
	for _, k := range keys {
		parts = append(parts, fmt.Sprintf("%s %s", KeyStyle.Render("["+k[0]+"]"), HelpStyle.Render(k[1])))
	}
	return strings.Join(parts, " - ")
}
