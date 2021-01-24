#!/usr/bin/env bash

# Setup
readonly BASE_PATH="${0%/install.sh}"

cd "$BASE_PATH"

# Install Apps / Dependencies
## Brew
if ! which brew &> /dev/null; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
brew bundle

# Install configs
## Install vimrc
ln -sf "${BASE_PATH}/configs/vimrc" "${HOME}/.vimrc"

## Install configs
ln -sf "${BASE_PATH}/configs/zshrc" "${HOME}/.zshrc"
ln -sf "${BASE_PATH}/configs/zprofile" "${HOME}/.zprofile"
ln -sF "${BASE_PATH}/zsh_functions" "${HOME}/.zsh_functions"

## Install htoprc
mkdir -p "${HOME}/.config/htop"
ln -sf "${BASE_PATH}/configs/htoprc" "${HOME}/.config/htop/htoprc"

## Install karabiner config
mkdir -p "${HOME}/.config/karabiner"
ln -sf "${BASE_PATH}/configs/karabiner.json" "${HOME}/.config/karabiner/karabiner.json"

## Install iterm2 Prefs
ln -sf "${BASE_PATH}/configs/iterm2.plist" "${HOME}/Library/Preferences/com.googlecode.iterm2.plist"

## Global git configs
ln -sf "${BASE_PATH}/configs/gitconfig" "${HOME}/.gitconfig"
ln -sf "${BASE_PATH}/configs/gitignore_global" "${HOME}/.gitignore_global"


