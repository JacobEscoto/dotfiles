package config

type SymlinkItem struct {
	Name      string
	SourceRel string
	TargetRel string
}

type PackageItem struct {
	Name        string
	Binary      string   // Command to check with exec.LookPath
	AptPackages []string // APT package names
	BrewFormula string   // Brew formula name if managed via brew
}

// GetDefaultSymlinks returns all dotfiles to link into ~/.config or ~
func GetDefaultSymlinks() []SymlinkItem {
	return []SymlinkItem{
		{Name: "kitty", SourceRel: "kitty", TargetRel: ".config/kitty"},
		{Name: "i3", SourceRel: "i3", TargetRel: ".config/i3"},
		{Name: "polybar", SourceRel: "polybar", TargetRel: ".config/polybar"},
		{Name: "rofi", SourceRel: "rofi", TargetRel: ".config/rofi"},
		{Name: "picom", SourceRel: "picom", TargetRel: ".config/picom"},
		{Name: "dunst", SourceRel: "dunst", TargetRel: ".config/dunst"},
		{Name: "nvim", SourceRel: "nvim", TargetRel: ".config/nvim"},
		{Name: "micro", SourceRel: "micro", TargetRel: ".config/micro"},
		{Name: "superfile", SourceRel: "superfile", TargetRel: ".config/superfile"},
		{Name: "fastfetch", SourceRel: "fastfetch", TargetRel: ".config/fastfetch"},
		{Name: "betterlockscreen", SourceRel: "betterlockscreen", TargetRel: ".config/betterlockscreen"},
		{Name: "starship", SourceRel: "starship/starship.toml", TargetRel: ".config/starship.toml"},
		{Name: "fish", SourceRel: "fish", TargetRel: ".config/fish"},
		{Name: "git", SourceRel: "git/.gitconfig", TargetRel: ".gitconfig"},
	}
}

// GetAptPackages returns Debian/Ubuntu system packages to batch-install via apt
func GetAptPackages() []PackageItem {
	return []PackageItem{
		{Name: "fish", Binary: "fish", AptPackages: []string{"fish"}},
		{Name: "kitty", Binary: "kitty", AptPackages: []string{"kitty"}},
		{Name: "i3", Binary: "i3", AptPackages: []string{"i3", "i3lock"}},
		{Name: "polybar", Binary: "polybar", AptPackages: []string{"polybar"}},
		{Name: "rofi", Binary: "rofi", AptPackages: []string{"rofi"}},
		{Name: "picom", Binary: "picom", AptPackages: []string{"picom"}},
		{Name: "dunst", Binary: "dunst", AptPackages: []string{"dunst"}},
		{Name: "neovim", Binary: "nvim", AptPackages: []string{"neovim"}},
		{Name: "micro", Binary: "micro", AptPackages: []string{"micro"}},
		{Name: "git", Binary: "git", AptPackages: []string{"git"}},
		{Name: "curl", Binary: "curl", AptPackages: []string{"curl", "wget"}},
		{Name: "build-essential", Binary: "gcc", AptPackages: []string{"build-essential", "gcc", "make"}},
		{Name: "x11-utils", Binary: "feh", AptPackages: []string{"feh", "maim", "xclip"}},
		{Name: "fonts", Binary: "", AptPackages: []string{"fonts-font-awesome", "papirus-icon-theme"}},
	}
}

// GetBrewPackages returns CLI formulas to batch-install via linuxbrew
func GetBrewPackages() []PackageItem {
	return []PackageItem{
		{Name: "starship", Binary: "starship", BrewFormula: "starship"},
		{Name: "fastfetch", Binary: "fastfetch", BrewFormula: "fastfetch"},
		{Name: "eza", Binary: "eza", BrewFormula: "eza"},
		{Name: "bat", Binary: "bat", BrewFormula: "bat"},
		{Name: "fzf", Binary: "fzf", BrewFormula: "fzf"},
		{Name: "zoxide", Binary: "zoxide", BrewFormula: "zoxide"},
		{Name: "ripgrep", Binary: "rg", BrewFormula: "ripgrep"},
		{Name: "fd", Binary: "fd", BrewFormula: "fd"},
		{Name: "lazygit", Binary: "lazygit", BrewFormula: "lazygit"},
	}
}
