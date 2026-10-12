#!/usr/bin/env bash
# Resilient wallpaper setter for i3 & betterlockscreen integration

DEFAULT_WALLPAPER_PATH="${HOME}/dotfiles/wallpapers/forest-wallpaper.jpg"
FALLBACK_PICTURES_PATH="${HOME}/Pictures/forest-wallpaper.jpg"

WALLPAPER=""
if [ -n "$1" ] && [ -f "$1" ]; then
  WALLPAPER="$1"
elif [ -f "$DEFAULT_WALLPAPER_PATH" ]; then
  WALLPAPER="$DEFAULT_WALLPAPER_PATH"
elif [ -f "$FALLBACK_PICTURES_PATH" ]; then
  WALLPAPER="$FALLBACK_PICTURES_PATH"
else
  # Find any jpg/png in wallpapers dir
  WALLPAPER=$(find "${HOME}/dotfiles/wallpapers" -maxdepth 1 -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) 2>/dev/null | head -n 1)
fi

if [ -n "$WALLPAPER" ] && [ -f "$WALLPAPER" ]; then
  # Set desktop background across all connected outputs
  feh --no-fehbg --bg-fill "$WALLPAPER"

  # Cache lockscreen image in background if betterlockscreen exists and cache is missing or wallpaper changed
  if command -v betterlockscreen >/dev/null 2>&1; then
    (betterlockscreen -u "$WALLPAPER" >/dev/null 2>&1 &)
  fi
fi
