#!/bin/bash

brew update && brew upgrade

brew install antigen
brew install ctags
brew install git
brew install htop
brew install netcat
brew install netperf
brew install node
brew install pidcat
brew install python
brew install rbenv
brew install reattach-to-user-namespace
brew install s3cmd
brew install sox
brew install swaks
brew install swiftlint
brew install tmux
brew install trash
brew install tree
brew install vim

brew cask install appcode
brew cask install arq
brew cask install boxer
brew cask install caffeine
brew cask install cyberduck
brew cask install daisydisk
brew cask install dash
brew cask install diffmerge
brew cask install dolphin
brew cask install dropbox
brew cask install flux
brew cask install franz
brew cask install geekbench
brew cask install google-chrome
brew cask install google-hangouts
brew cask install icons8
brew cask install imageoptim
brew cask install intellij-idea
brew cask install invisionsync
brew cask install istat-menus
brew cask install java
brew cask install macvim
brew cask install mou
brew cask install mp4tools
brew cask install mplayerx
brew cask install openemu
brew cask install parallels-desktop
brew cask install pycharm
brew cask install sequel-pro
brew cask install sketch
brew cask install skype
brew cask install sourcetree
brew cask install spotify
brew cask install sqlitebrowser
brew cask install transmission
brew cask install vlc
brew cask install webstorm
brew cask install xbench
brew cask install zeplin

brew doctor
brew cleanup && brew prune && brew cask cleanup


