# Disable initial greeting
set -g fish_greeting ""

# Environment variables
set -gx MICRO_TRUECOLOR 1
set -gx XDG_MENU_PREFIX plasma-

# Add local and Go binaries to PATH
fish_add_path ~/.local/bin
fish_add_path ~/go/bin

# Linuxbrew environment setup
if test -d /home/linuxbrew/.linuxbrew
    /home/linuxbrew/.linuxbrew/bin/brew shellenv | source
end

if status is-interactive
  # Abbreviations for system commands
  abbr -a reload "exec fish"
  abbr -a fish-config "nvim ~/.config/fish/config.fish"

  # File list (eza)
  abbr -a ls "eza --icons=always --group-directories-first"
  abbr -a ll "eza --icons=always --group-directories-first --long --header --git --time-style=relative"
  abbr -a la "eza --icons=always --group-directories-first --long --header --git --all"
  abbr -a tree "eza --icons=always --tree --level=3 --ignore-glob='node_modules|.git|build|.cache'"
  abbr -a treell "eza --icons=always --tree --long --header --git --ignore-glob='node_modules|.git|build|.cache'"
  abbr -a lsd "eza --icons=always --only-dirs"
  abbr -a lsf "eza --icons=always --only-files"

  # Syntax Colors
  set -g fish_color_command 76abdf
  set -g fish_color_param c9ffe5
  set -g fish_color_keyword cba6f7
  set -g fish_color_quote a5b4fc
  set -g fish_color_redirection 0492c2
  set -g fish_color_end 76abdf
  set -g fish_color_error fb4934
  set -g fish_color_autosuggestion 475569

  set -g fish_color_search_match --background=151e3d
  set -g fish_color_selection --background=151e3d
  set -g fish_color_operator 0492c2
  set -g fish_color_escape cba6f7

  # Start SSH agent
  if not set -q SSH_AUTH_SOCK
    eval (ssh-agent -c) > /dev/null
    ssh-add ~/.ssh/id_22519 2> /dev/null
  end

  # Interactive tools
  zoxide init fish | source
  starship init fish | source

  # Welcome
  fastfetch
end
