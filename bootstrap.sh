#!/bin/bash

function doIt() {
    # Install homebrew
    echo "Installing homebrew..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

    # Configure OS X
    echo "Configuring OS X..."
    sh .macos

    # Install brews & casks
    echo "Installing brews..."
    sh install-brews.sh

    # Install Vundle package manager for VIM
    echo "Installing Vundle plugin manager for VIM..."
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

    echo "Creating symbolic links for dotfiles"
    cd ~
    rm .aliases; ln -s dotfiles/.aliases
    rm .antigenrc; ln -s dotfiles/.antigenrc
    rm .bash_profile; ln -s dotfiles/.bash_profile
    rm .ec2cfg; ln -s dotfiles/.ec2cfg
    rm .functions; ln -s dotfiles/.functions
    rm .gitconfig; ln -s dotfiles/.gitconfig
    rm .s3cfg; ln -s dotfiles/.s3cfg
    rm .tmux.conf; ln -s dotfiles/.tmux.conf
    rm .vimrc; ln -s dotfiles/.vimrc
    rm .vimrc.bundles; ln -s dotfiles/.vimrc.bundles
    rm .zshrc; ln -s dotfiles/.zshrc

    ln -s dotfiles/bin

    mkdir -p .gradle
    cd .gradle
    rm gradle.properties; ln -s ~/dotfiles/.gradle/gradle.properties
    cd ~

    chflags hidden bin
    chflags hidden dotfiles
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





