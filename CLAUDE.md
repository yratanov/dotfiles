# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for Arch Linux with Hyprland (Wayland). It manages configuration files using GNU Stow with a `dot-` prefix convention.

## Deployment Commands

```bash
# Deploy all configs (requires stow 2.4.1+)
dot-bin/sync-dotfiles

# Initial Arch Linux machine setup
dot-bin/initial-setup
```

IMPORTANT! Make sure to update initial-setup on changes

The sync script runs: `stow --dotfiles --adopt --target=$HOME .`

This converts `dot-` prefixed files to dotfiles (e.g., `dot-zshrc` → `~/.zshrc`).

## Architecture

### Directory Structure
- `dot-bin/` - Utility scripts (added to PATH)
- `dot-config/` - XDG config directory contents (~/.config/)
- `dot-zshrc`, `dot-tmux.conf`, `dot-gitconfig` - Home directory dotfiles

### Key Configurations

**Hyprland** (`dot-config/hypr/`):
- `hyprland.conf` - Core compositor settings
- `bindings.conf` - Keybindings
- `autostart.conf` - Startup applications
- `windows-workspaces.conf` - Window rules

**Neovim** (`dot-config/nvim/`):
- Uses Lazy.nvim plugin manager
- Plugin configs in `lua/plugins/` (one file per plugin)
- Main config in `lua/config/`

**Tmuxinator** (`dot-config/tmuxinator/`):
- Session layouts for projects (pulse-api, pulse-frontend, etc.)

### Consistent Theming
- Everforest color scheme across all tools
- JetBrainsMono Nerd Font

### Development Context
- Rails/Ruby and Ember.js focused
- Extensive SSH shortcuts to remote environments in `dot-zshrc`
- Docker aliases and configurations
