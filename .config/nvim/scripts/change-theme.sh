#!/bin/bash

export PATH="/opt/homebrew/bin:$PATH"

defaults read -g AppleInterfaceStyle 2>/dev/null

if [ $? -eq 0 ]; then
  variant="dark"
else
  variant="light"
fi

if [ "$variant" = "dark" ]; then
  /opt/homebrew/bin/tmux set -g @rose_pine_variant 'main'
  theme_name="rose-pine"
elif [ "$variant" = "light" ]; then
  /opt/homebrew/bin/tmux set -g @rose_pine_variant 'dawn'
  theme_name="rose-pine-dawn"
else
  echo "Invalid theme variant: $variant"
  exit 1 
fi

~/.tmux/plugins/tpm/tpm

# Update the theme name in the YAML file
sed -i "" "s|~/.config/alacritty/themes/themes/rose-pine[^.]*\.yaml|~/.config/alacritty/themes/themes/${theme_name}.yaml|" ~/.config/alacritty/alacritty.yml 

exit 0

