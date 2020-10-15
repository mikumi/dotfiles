#!/bin/bash
INSTALLATION_TYPE=$1

brew update && brew upgrade

echo ""
echo "Installing BASIC brews..."
echo ""

# BASIC NON-DEV STUFF
brew install antigen
brew install ccat # color cat
brew install dockutil
brew install exa
brew install fzf
brew install git
brew install git-lfs
brew install jq
brew install --HEAD -s mosh # from source for unpublished OSC 52 fix
brew install nmap
brew install reattach-to-user-namespace
brew install speedtest_cli
brew install telnet
brew install tmux
brew install vim
brew install trash

# DEVELOPMENT AND OTHER DAILY STUFF
if [ "$INSTALLATION_TYPE" != "BASIC" ]; then
    echo ""
    echo "Installing DEFAULT brews..."
    echo ""
    brew install awscli
    brew install cmake
    brew install coreutils
    brew install ctags
    brew install ctop
    brew install docker-compose
    brew install docker-machine
    brew install doctl
    brew install fastlane
    brew install htop
    brew install httpie
    brew install nativefier
    brew install netcat
    brew install node
    brew install nvm
    brew install pkg-config
    brew install pidcat
    brew install s3cmd
    brew install speedtest-cli
    brew install sox
    brew install swaks
    brew install swiftlint
    brew install telnet
    brew install tldr
    brew install tree
    brew install watch
fi

# EVERYTHING ELSE
if [ "$INSTALLATION_TYPE" == "FULL" ]; then
    echo ""
    echo "Installing FULL brews..."
    echo ""
    brew install exiftool
    brew install ffmpeg
    brew install ghostscript
    brew install imagemagick
    brew install mpv
    brew install mplayer
fi

brew doctor
brew cleanup

