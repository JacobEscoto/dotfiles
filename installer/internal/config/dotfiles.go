package config

import (
	"os"
	"path/filepath"
)

type SymlinkItem struct {
	ID          string `json:"id"`
	Name        string `json:"name"`
	Description string `json:"description"`
	SourceRel   string `json:"source_rel"` // Relative to dotfiles root
	TargetRel   string `json:"target_rel"` // Relative to Home (~/...)
	Selected    bool   `json:"selected"`
}

type PackageItem struct {
	ID             string   `json:"id"`
	Name           string   `json:"name"`
	Category       string   `json:"category"`
	Description    string   `json:"description"`
	AptPackages    []string `json:"apt_packages"`
	BinaryCheck    string   `json:"binary_check"`
	InstallScript  string   `json:"install_script,omitempty"`
	Selected       bool     `json:"selected"`
}

func GetDefaultSymlinks() []SymlinkItem {
	return []SymlinkItem{
		{
			ID:          "fish",
			Name:        "Fish Shell Config",
			Description: "Fish shell functions, variables & plugins (~/.config/fish)",
			SourceRel:   "fish",
			TargetRel:   ".config/fish",
			Selected:    true,
		},
		{
			ID:          "starship",
			Name:        "Starship Prompt",
			Description: "Starship cross-shell prompt config (~/.config/starship.toml)",
			SourceRel:   "starship/starship.toml",
			TargetRel:   ".config/starship.toml",
			Selected:    true,
		},
		{
			ID:          "kitty",
			Name:        "Kitty Terminal",
			Description: "Kitty terminal configuration (~/.config/kitty)",
			SourceRel:   "kitty",
			TargetRel:   ".config/kitty",
			Selected:    true,
		},
		{
			ID:          "i3",
			Name:        "i3 Window Manager",
			Description: "i3 window manager config & helper scripts (~/.config/i3)",
			SourceRel:   "i3",
			TargetRel:   ".config/i3",
			Selected:    true,
		},
		{
			ID:          "polybar",
			Name:        "Polybar Status Bar",
			Description: "Polybar modules, launch script & themes (~/.config/polybar)",
			SourceRel:   "polybar",
			TargetRel:   ".config/polybar",
			Selected:    true,
		},
		{
			ID:          "rofi",
			Name:        "Rofi Menu Launcher",
			Description: "Rofi launchers, menus & styles (~/.config/rofi)",
			SourceRel:   "rofi",
			TargetRel:   ".config/rofi",
			Selected:    true,
		},
		{
			ID:          "picom",
			Name:        "Picom Compositor",
			Description: "Picom X11 compositor config (~/.config/picom)",
			SourceRel:   "picom",
			TargetRel:   ".config/picom",
			Selected:    true,
		},
		{
			ID:          "dunst",
			Name:        "Dunst Notifications",
			Description: "Dunst notification daemon settings (~/.config/dunst)",
			SourceRel:   "dunst",
			TargetRel:   ".config/dunst",
			Selected:    true,
		},
		{
			ID:          "nvim",
			Name:        "Neovim Config",
			Description: "Lua-based Neovim development setup (~/.config/nvim)",
			SourceRel:   "nvim",
			TargetRel:   ".config/nvim",
			Selected:    true,
		},
		{
			ID:          "micro",
			Name:        "Micro Text Editor",
			Description: "Micro settings, keybindings & colorschemes (~/.config/micro)",
			SourceRel:   "micro",
			TargetRel:   ".config/micro",
			Selected:    true,
		},
		{
			ID:          "superfile",
			Name:        "Superfile File Manager",
			Description: "Superfile theme & hotkeys config (~/.config/superfile)",
			SourceRel:   "superfile",
			TargetRel:   ".config/superfile",
			Selected:    true,
		},
		{
			ID:          "fastfetch",
			Name:        "Fastfetch System Info",
			Description: "Fastfetch dashboard layout & image asset (~/.config/fastfetch)",
			SourceRel:   "fastfetch",
			TargetRel:   ".config/fastfetch",
			Selected:    true,
		},
		{
			ID:          "betterlockscreen",
			Name:        "Betterlockscreen",
			Description: "Lock screen customization file (~/.config/betterlockscreen)",
			SourceRel:   "betterlockscreen",
			TargetRel:   ".config/betterlockscreen",
			Selected:    true,
		},
		{
			ID:          "git",
			Name:        "Git Global Config",
			Description: "Global Git user preferences (~/.gitconfig)",
			SourceRel:   "git/.gitconfig",
			TargetRel:   ".gitconfig",
			Selected:    true,
		},
	}
}

func GetDefaultPackages() []PackageItem {
	return []PackageItem{
		// Shell & Terminal
		{
			ID:          "fish",
			Name:        "Fish Shell",
			Category:    "Shell & Terminal",
			Description: "Smart and user-friendly command line shell",
			AptPackages: []string{"fish"},
			BinaryCheck: "fish",
			Selected:    true,
		},
		{
			ID:            "starship",
			Name:          "Starship Prompt",
			Category:      "Shell & Terminal",
			Description:   "The minimal, blazing-fast, and customizable prompt",
			AptPackages:   []string{"starship"},
			BinaryCheck:   "starship",
			InstallScript: "curl -sS https://starship.rs/install.sh | sh -s -- -y",
			Selected:      true,
		},
		{
			ID:          "kitty",
			Name:        "Kitty Terminal",
			Category:    "Shell & Terminal",
			Description: "Fast, feature-rich GPU-based terminal emulator",
			AptPackages: []string{"kitty"},
			BinaryCheck: "kitty",
			Selected:    true,
		},
		{
			ID:          "fastfetch",
			Name:        "Fastfetch",
			Category:    "Shell & Terminal",
			Description: "Neofetch-like tool for fetching system information",
			AptPackages: []string{"fastfetch"},
			BinaryCheck: "fastfetch",
			Selected:    true,
		},

		// Editors & Tools
		{
			ID:          "neovim",
			Name:        "Neovim",
			Category:    "Editors & Tools",
			Description: "Vim-fork focused on extensibility and usability",
			AptPackages: []string{"neovim"},
			BinaryCheck: "nvim",
			Selected:    true,
		},
		{
			ID:          "micro",
			Name:        "Micro Editor",
			Category:    "Editors & Tools",
			Description: "Modern and intuitive terminal-based text editor",
			AptPackages: []string{"micro"},
			BinaryCheck: "micro",
			Selected:    true,
		},
		{
			ID:            "superfile",
			Name:          "Superfile",
			Category:      "Editors & Tools",
			Description:   "Fancy terminal file manager with preview support",
			AptPackages:   []string{"superfile"},
			BinaryCheck:   "spf",
			InstallScript: "bash -c '$(curl -sS https://superfile.netlify.app/install.sh)'",
			Selected:      true,
		},

		// Desktop & Window Manager
		{
			ID:          "i3",
			Name:        "i3 Window Manager",
			Category:    "Desktop Environment",
			Description: "Improved tiling window manager for X11",
			AptPackages: []string{"i3", "i3lock"},
			BinaryCheck: "i3",
			Selected:    true,
		},
		{
			ID:          "polybar",
			Name:        "Polybar",
			Category:    "Desktop Environment",
			Description: "Fast and customizable status bar",
			AptPackages: []string{"polybar"},
			BinaryCheck: "polybar",
			Selected:    true,
		},
		{
			ID:          "rofi",
			Name:        "Rofi Menu",
			Category:    "Desktop Environment",
			Description: "Window switcher, application launcher, and dmenu replacement",
			AptPackages: []string{"rofi"},
			BinaryCheck: "rofi",
			Selected:    true,
		},
		{
			ID:          "picom",
			Name:        "Picom Compositor",
			Category:    "Desktop Environment",
			Description: "Lightweight compositor for X11 transparency & shadows",
			AptPackages: []string{"picom"},
			BinaryCheck: "picom",
			Selected:    true,
		},
		{
			ID:          "dunst",
			Name:        "Dunst",
			Category:    "Desktop Environment",
			Description: "Lightweight notification daemon",
			AptPackages: []string{"dunst"},
			BinaryCheck: "dunst",
			Selected:    true,
		},
		{
			ID:          "betterlockscreen",
			Name:        "Betterlockscreen",
			Category:    "Desktop Environment",
			Description: "Sweet lockscreen for i3 and X11 environments",
			AptPackages: []string{"betterlockscreen", "i3lock-color"},
			BinaryCheck: "betterlockscreen",
			Selected:    true,
		},

		// Utilities & Fonts
		{
			ID:          "git",
			Name:        "Git",
			Category:    "Utilities & System",
			Description: "Distributed version control system",
			AptPackages: []string{"git"},
			BinaryCheck: "git",
			Selected:    true,
		},
		{
			ID:          "curl",
			Name:        "cURL & Wget",
			Category:    "Utilities & System",
			Description: "Command line tools for transferring data with URLs",
			AptPackages: []string{"curl", "wget"},
			BinaryCheck: "curl",
			Selected:    true,
		},
		{
			ID:          "build-tools",
			Name:        "Build Essentials",
			Category:    "Utilities & System",
			Description: "C/C++ compiler and development libraries",
			AptPackages: []string{"build-essential", "gcc", "make"},
			BinaryCheck: "gcc",
			Selected:    true,
		},
		{
			ID:          "x11-utils",
			Name:        "X11 Display Utilities",
			Category:    "Utilities & System",
			Description: "Wallpaper setter (feh), screenshots (maim) & clipboard (xclip)",
			AptPackages: []string{"feh", "maim", "xclip"},
			BinaryCheck: "feh",
			Selected:    true,
		},
		{
			ID:          "fonts",
			Name:        "Font Awesome & Icon Fonts",
			Category:    "Utilities & System",
			Description: "Icon fonts for polybar, starship, and rofi",
			AptPackages: []string{"fonts-font-awesome", "papirus-icon-theme"},
			BinaryCheck: "",
			Selected:    true,
		},
	}
}

func ExpandPath(path string) (string, error) {
	if len(path) > 0 && path[0] == '~' {
		home, err := os.UserHomeDir()
		if err != nil {
			return "", err
		}
		return filepath.Join(home, path[1:]), nil
	}
	return path, nil
}
