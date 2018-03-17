#!/bin/bash

function doIt() {
    if [[ `uname` == 'Darwin' ]] ; then
        # Install homebrew
        echo "Installing homebrew..."
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

        # Configure OS X
        echo "Configuring OS X..."
        sh .macos

        # Install Mac App Store apps
        echo "Installing Mac App Store apps..."
        brew install mas $INSTALLATION_TYPE $EMAIL_DE $EMAIL_US
        sh install-mas.sh

        # Install brews
        echo "Installing brews..."
        sh install-brews.sh $INSTALLATION_TYPE

        # Install casks
        echo "Installing casks..."
        sh install-casks.sh $INSTALLATION_TYPE
    fi

    if [[ `uname` == 'Linux' ]] ; then
        sudo apt-get update
        sudo apt-get install build-essential curl zsh tmux vim
        sudo mkdir -p /usr/local/share/antigen
        sudo sh -c 'curl https://cdn.rawgit.com/zsh-users/antigen/v1.4.0/bin/antigen.zsh > /usr/local/share/antigen/antigen.zsh'
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
        .ctags \
        .ec2cfg \
        .functions \
        .gitconfig \
        .ideavimrc \
        .npmrc \
        .s3cfg \
        .tmux.conf \
        .tmux.remote.conf \
        .vimrc \
        .vimrc.bundles \
        .zprofile
    )
    for file in $dotfiles ; do
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

    if [[ `uname` == 'Darwin' ]] ; then
        dockutil --remove all
        sh configure-dock.sh
        killall Dock

        chflags hidden bin
        chflags hidden dotfiles
    fi
}

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





