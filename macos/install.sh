#!/usr/bin/env bash

# Setup
readonly BASE_PATH="$PWD"
BACKUP=false
BACKUPDIR="${HOME}/ConfigBackups"

function usage {
    printf "\nUsage: ${0##*/} [OPTIONS ...] -c COMMAND\n"
    printf "\nOptions:\n"
    printf "    -h          Displays this help message and exits\n"
    printf "    -b          Creates backups of original files in ${BACKUPDIR}\n"

    printf "\nCommands:\n"
    printf "    all             Installs packages and deploys config files\n"
    printf "    packages        Only installs packages\n"
    printf "    configs         Only deploys configs\n"

}

cd "$BASE_PATH"

while getopts ":hb" opt; do
	case $opt in
		h )
			usage
			exit 0
			;;
		b )
			BACKUP=true
			;;
		: )
			echo "Option ${OPTARG} requires argument" 1>&2
			exit 1
			;;
		\? )
			echo "Invalid option ${OPTARG}" 1>&2
			;;
	esac
done
shift "$((OPTIND -1))"

SUBCMD="${1:-'all'}"

function install_packages {
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
}

function install_configs {
mkdir -p $BACKUPDIR
# Install configs
## Install vimrc
if $BACKUP; then
	cp "${HOME}/.vimrc" "${BACKUPDIR}/vimrc"
	cp "${HOME}/.zshrc" "${BACKUPDIR}/zshrc"
	cp "${HOME}/.zprofile" "${BACKUPDIR}/zprofile"
	cp "${HOME}/.config/htop/htoprc" "${BACKUPDIR}/htoprc"
	cp "${HOME}/.config/karabiner/karabiner.json" "${BACKUPDIR}/karabiner.json"
	cp "${HOME}/.gitconfig" "${BACKUPDIR}/gitconfig"
	cp "${HOME}/.gitignore_global" "${BACKUPDIR}/gitignore_global"
fi

ln -sf "${BASE_PATH}/configs/vimrc" "${HOME}/.vimrc"
mkdir -p "${HOME}/.vim_backups"
vim +PluginInstall +qall

## Install configs
ln -sf "${BASE_PATH}/configs/zshrc" "${HOME}/.zshrc"
mkdir -p "${HOME}/.zshrc.d"
ln -sf "${BASE_PATH}/configs/zprofile" "${HOME}/.zprofile"
mkdir -p "${HOME}/.zprofile.d"
ln -sF "${BASE_PATH}/zsh_functions" "${HOME}/.zsh_functions"

## Install htoprc
mkdir -p "${HOME}/.config/htop"
ln -sf "${BASE_PATH}/configs/htoprc" "${HOME}/.config/htop/htoprc"

## Install karabiner config
mkdir -p "${HOME}/.config/karabiner"
ln -sf "${BASE_PATH}/configs/karabiner.json" "${HOME}/.config/karabiner/karabiner.json"

## Install iterm2 Prefs
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -int 1
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "${BASE_PATH}/configs"

## Global git configs
ln -sf "${BASE_PATH}/configs/gitconfig" "${HOME}/.gitconfig"
ln -sf "${BASE_PATH}/configs/gitignore_global" "${HOME}/.gitignore_global"
}


case $SUBCMD in
	all )
		install_packages
		install_configs
		;;
	packages )
		install_packages
		;;
	configs )
		install_configs
		;;
	* )
		echo "Invalid command: $SUBCMD"
		exit 1
		;;
esac
