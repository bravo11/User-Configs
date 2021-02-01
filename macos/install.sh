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

## Karabiner
karabiner_version="$(curl -s https://api.github.com/repos/pqrs-org/Karabiner-Elements/releases/latest \
	| grep "tag_name" \ 
	| sed -E 's/.*"v(.*)",/\1/')"

karabiner_name="Karabiner-Elements-${karabiner_version}.dmg"

curl -L -o "$karabiner_name" \
		"https://github.com/pqrs-org/Karabiner-Elements/releases/download/v$karabiner_version/$karabiner_name"

echo "Please install Karabiner-Elements:"

open -a finder $karabiner_name 

read -p "Press Enter when done" _

# Install configs
## Install vimrc
ln -sf "${BASE_PATH}/configs/vimrc" "${HOME}/.vimrc"
mkdir -p "${HOME}/.vim_backups"
vim +PluginInstall +qall

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
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -int 1
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "${BASE_PATH}/configs/com.googlecode.iterm2.plist"

## Global git configs
ln -sf "${BASE_PATH}/configs/gitconfig" "${HOME}/.gitconfig"
ln -sf "${BASE_PATH}/configs/gitignore_global" "${HOME}/.gitignore_global"


