#!/bin/bash
INSTALLATION_TYPE=$1

brew update && brew upgrade

echo ""
echo "Installing BASIC brews..."
echo ""

brew install antigen
brew install ccat
brew install dockutil
brew install fzf
brew install git
brew install git-lfs
brew install grc
brew install jq
brew install mosh
brew install reattach-to-user-namespace
brew install speedtest_cli
brew install telnet
brew install tmux
brew install vim
brew install trash

if [ "$INSTALLATION_TYPE" != "BASIC" ]; then
    echo ""
    echo "Installing DEFAULT brews..."
    echo ""
    brew install awscli
    brew install cmake
    brew install ctags
    brew install docker-compose
    brew install docker-machine
    brew install httpie
    brew install hub
    brew install netcat
    brew install netperf
    brew install node
    brew install pidcat
    brew install s3cmd
    brew install sox
    brew install swaks
    brew install swiftlint
    brew install tldr
    brew install tree
fi

if [ "$INSTALLATION_TYPE" == "FULL" ]; then
    echo ""
    echo "Installing FULL brews..."
    echo ""
    brew install exiftool
    brew install ffmpeg
    brew install mpv
    brew install mplayer
fi

brew doctor
brew cleanup

