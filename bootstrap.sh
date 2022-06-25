#!/bin/bash

function doIt() {
    if [[ `uname` == 'Darwin' ]] ; then
        # Install homebrew
        echo "Installing homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
        brew tap homebrew/cask-fonts

        # Configure OS X
        echo "Configuring OS X..."
        sh .macos

        # Install apps
        brew bundle install Brewfile
    fi

    if [[ `uname` == 'Linux' ]] ; then
        # Install basics
        echo "Installing basic apt packages..."
        sudo apt-get update
        sudo apt-get install build-essential curl zsh locales
        sudo locale-gen en_US.UTF-8

        # Install homebrew
        echo "Installing homebrew..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
        echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >>~/.profile
        eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
        brew install gcc@7

        # Install apps
        brew bundle install Brewfile
    fi

    # Install Vundle package manager for VIM
    echo "Installing Vundle plugin manager for VIM..."
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

    cd ~
    echo "Creating symbolic links for dotfiles"
    dotfiles=(
        .aliases \
        .antigenrc \
        .bash_profile \
        .bashrc \
        .ctags \
        .ec2cfg \
        .functions \
        .gitconfig \
        .hyper.js \
        .ideavimrc \
        .npmrc \
        .p10k.zsh
        .spaceship \
        .s3cfg \
        .tmux.conf \
        .tmux.remote.conf \
        .vimrc \
        .vimrc.bundles \
        .zshrc \
        .zprofile
    )
    for file in ${dotfiles[@]} ; do
        rm $file
        ln -s dotfiles/$file
    done
    unset dotfiles file

    ln -s dotfiles/bin

    mkdir -p .gradle
    cd .gradle
    rm gradle.properties; ln -s ~/dotfiles/.gradle/gradle.properties
    cd ~

    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

    vim +PluginInstall +qall

    mkdir -p ~/.hyper_plugins
    cd ~/.hyper_plugins
    ln -s ~/dotfiles/.hyper_plugins/local
    cd

    chsh -s /bin/zsh

    if [[ `uname` == 'Darwin' ]] ; then
        dockutil --remove all --no-restart
        sh dotfiles/configure-dock.sh
        killall Dock

        chflags hidden bin
        chflags hidden dotfiles
    fi
}

function printUsage() {
    echo "./bootstrap.sh --email-de=<email> --email-us=<email> --installation-type=<type>"
    echo ""
    echo "    --email-de               German App Store email (required on Mac only)"
    echo "    --email-us               US App Store email (required on Mac only)"
    echo "    --installation           [basic|default|full] (required)"
}

function validateCmdArgs() {
    if [ -z $INSTALLATION_TYPE ]; then
        printUsage;
        exit
    fi
    if [[ `uname` == 'Darwin' ]] ; then
        if [ -z $EMAIL_DE ] || [ -z $EMAIL_US ]; then
            printUsage;
            exit
        fi
    fi
    echo ""
    echo "App Store Email (Germany)  = ${EMAIL_DE}"
    echo "App Store Email (US)       = ${EMAIL_US}"
    echo "Installation type          = ${INSTALLATION_TYPE}"
}

for i in "$@"
do
case $i in
    --email-de=*)
    EMAIL_DE="${i#*=}"
    shift # past argument=value
    ;;
    --email-us=*)
    EMAIL_US="${i#*=}"
    shift # past argument=value
    ;;
    -i=*|--installation=*)
    INSTALLATION_TYPE=$(echo "${i#*=}" | awk '{print toupper($0)}')
    shift # past argument=value
    ;;
    *)
        # unknown option
    ;;
esac
done

validateCmdArgs;


if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read -p "This may overwrite existing files. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;





