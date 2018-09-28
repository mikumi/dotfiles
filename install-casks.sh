#!/bin/bash
INSTALLATION_TYPE=$1

echo ""
echo "Installing BASIC casks..."
echo ""

brew cask install 1password
brew cask install dropbox
brew cask install sublime-text

if [ "$INSTALLATION_TYPE" != "BASIC" ]; then
    echo ""
    echo "Installing DEFAULT casks..."
    echo ""
    brew cask install android-studio
    brew cask install appcleaner
    brew cask install arq
    brew cask install caffeine
    brew cask install dash
    brew cask install diffmerge
    brew cask install docker
    brew cask install expressvpn
    brew cask install fastlane
    brew cask install fork
    brew cask install google-chrome
    brew cask install icons8
    brew cask install iina
    brew cask install istat-menus
    brew cask install jetbrains-toolbox
    brew cask install macvim
    brew cask install nordvpn
    brew cask install sequel-pro
    brew cask install sip
    brew cask install sketch
    brew cask install slack
    brew cask install whatsapp
    brew cask install zeplin
fi

if [ "$INSTALLATION_TYPE" == "FULL" ]; then
    echo ""
    echo "Installing FULL casks..."
    echo ""
    brew cask install aerial
    brew cask install boxer
    brew cask install cinebench
    brew cask install cyberduck
    brew cask install daisydisk
    brew cask install dolphin
    brew cask install geekbench
    brew cask install handbrake
    brew cask install imageoptim
    brew cask install mactracker
    brew cask install macdown
    brew cask install messenger
    brew cask install mp4tools
    brew cask install openemu
    brew cask install parallels
    brew cask install postman
    brew cask install skype
    brew cask install spotify
    brew cask install steveschow-gfxcardstatus
    brew cask install subtitles
fi

brew doctor
brew cleanup && brew prune
