#!/bin/bash
INSTALLATION_TYPE=$1

echo ""
echo "Installing BASIC casks..."
echo ""

# BASIC NON-DEV STUFF
brew cask install 1password
brew cask install alfred
brew cask install dropbox
brew cask install hyper
brew cask install font-fira-code
brew cask install font-hack-nerd-font
brew cask install sublime-text

# DEVELOPMENT AND OTHER DAILY STUFF
if [ "$INSTALLATION_TYPE" != "BASIC" ]; then
    echo ""
    echo "Installing DEFAULT casks..."
    echo ""
    brew cask install abstract
    brew cask install android-studio
    brew cask install appcleaner
    brew cask install appcode
    brew cask install backblaze-downloader
    brew cask install bettertouchtool
    brew cask install cakebrew
    brew cask install cyberduck
    brew cask install dash
    brew cask install diffmerge
    brew cask install docker
    brew cask install expressvpn
    brew cask install fastlane
    brew cask install fork
    brew cask install google-chrome
    brew cask install google-cloud-sdk
    brew cask install icons8
    brew cask install iina
    brew cask install imageoptim
    brew cask install intel-power-gadget
    brew cask install jetbrains-toolbox
    brew cask install keepingyouawake
    brew cask install macvim
    brew cask install ngrok
    brew cask install sequel-pro
    brew cask install sip
    brew cask install sketch
    brew cask install slack
    brew cask install turbo-boost-switcher
    brew cask install visual-studio-code
    brew cask install webstorm
    brew cask install whatsapp
    brew cask install xquartz
    brew cask install zeplin
fi

# EVERYTHING ELSE
if [ "$INSTALLATION_TYPE" == "FULL" ]; then
    echo ""
    echo "Installing FULL casks..."
    echo ""
    brew cask install adobe-creative-cloud
    brew cask install aerial
    brew cask install arq
    brew cask install backblaze
    brew cask install battle-net
    brew cask install boxer
    brew cask install cinebench
    brew cask install coconutbattery
    brew cask install daisydisk
    brew cask install datagrip
    brew cask install dolphin
    brew cask install fantastical
    brew cask install firefox
    brew cask install geekbench
    brew cask install google-backup-and-sync
    brew cask install handbrake
    brew cask install intellij-idea
    brew cask install istat-menus
    brew cask install mactracker
    brew cask install macdown
    brew cask install messenger
    brew cask install mp4tools
    brew cask install openemu
    brew cask install parallels
    brew cask install pycharm
    brew cask install postman
    brew cask install skype
    brew cask install spotify
    brew cask install steveschow-gfxcardstatus
    brew cask install upwork
    brew cask install xbench
fi

brew doctor
brew cleanup
