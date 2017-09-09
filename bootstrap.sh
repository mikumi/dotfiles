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
        brew install mas
        sh install-mas.sh

        # Install brews
        echo "Installing brews..."
        sh install-brews.sh

        # Install casks
        echo "Installing casks..."
        sh install-casks.sh
    fi

    if [[ `uname` == 'Linux' ]] ; then
        sudo apt-get update
        sudo apt-get install build-essential curl zsh tmux vim
        mkdir -p /usr/local/share/antigen
        curl https://cdn.rawgit.com/zsh-users/antigen/v1.4.0/bin/antigen.zsh > /usr/local/share/antigen/antigen.zsh
    fi

    # Install Vundle package manager for VIM
    echo "Installing Vundle plugin manager for VIM..."
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

    echo "Creating symbolic links for dotfiles"
    cd ~
    rm .aliases; ln -s dotfiles/.aliases
    rm .antigenrc; ln -s dotfiles/.antigenrc
    rm .bash_profile; ln -s dotfiles/.bash_profile
    rm .ctags; ln -s dotfiles/.ctags
    rm .ec2cfg; ln -s dotfiles/.ec2cfg
    rm .functions; ln -s dotfiles/.functions
    rm .gitconfig; ln -s dotfiles/.gitconfig
    rm .ideavimrc; ln -s dotfiles/.ideavimrc
    rm .npmrc; ln -s dotfiles/.npmrc
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

    vim +PluginInstall +qall

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





