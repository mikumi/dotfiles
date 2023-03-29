#!/bin/bash

echo "Installing dotfiles..."

DOTFILES=$HOME/dotfiles
SUDO=$([ "$(whoami)" != "root" ] && echo "sudo")

function main() {
  if [[ $(uname) == 'Linux' ]] ; then
    echo "Installing for linux..."
    installLinux
    # installRubyLinux # rbenv. required for DIY homebrew
    # installHomebrewLinux
  elif [[ $(uname) == 'Darwin' ]] ; then
    echo "Installing for macOS..."
    installMacOS
  fi
}

function installMacOS() {
  # Install homebrew
  echo "Installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  brew tap homebrew/cask-fonts

  # Configure OS X
  echo "Configuring OS X..."
  sh .macos

  # Install apps
  # brew bundle install Brewfile
  installCommon

  dockutil --remove all --no-restart
  sh dotfiles/configure-dock.sh
  killall Dock

  chflags hidden bin
  chflags hidden dotfiles
}

function installLinux() {
  echo "Installing basics..."
  $SUDO apt update
  $SUDO apt install -y \
    build-essential \
    curl \
    exa \
    git \
    libz-dev \
    locales \
    sshfs \
    tmux \
    vim \
    zsh
  $SUDO locale-gen en_US.UTF-8

  # installRubyLinux
  # installHomebrewLinux

  installCommon

  $SUDO chsh -s /bin/zsh $(whoami)

  curl -L git.io/antigen > antigen.zsh

  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
}

function installCommon() {
  cloneDotfiles
  cd $DOTFILES

  linkDotfiles

  installTPM
  installVundle
}

function installRubyLinux() {
  echo "Installing rbenv and ruby..."
  git clone https://github.com/rbenv/rbenv.git ~/.rbenv
  cd ~/.rbenv && src/configure && make -C src
  cd ~
  echo 'export PATH="$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH"' >> ~/.zshrc
  export PATH="$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH"
  ~/.rbenv/bin/rbenv init
  mkdir -p "$(rbenv root)"/plugins
  git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
  curl -fsSL https://github.com/rbenv/rbenv-installer/raw/main/bin/rbenv-doctor | bash
  eval "$(rbenv init - bash)"
  rbenv install 2.6.8
  rbenv global 2.6.8
}

function installHomebrewLinux() {
  echo "Installing homebrew..."
  # homebrew (DIY because otherwise doesn't work on ARM)
  # we could also detect platform and use the official installer for x64, but haven't done that yet
  mkdir homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew
  eval "$(homebrew/bin/brew shellenv)"
  brew update --force --quiet
  chmod -R go-w "$(brew --prefix)/share/zsh"
  # sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
  # echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >>~/.profile
  # eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  # brew install gcc@7
}

function cloneDotfiles() {
  if [ ! -d "$DOTFILES" ]; then
    echo "Cloning dotfiles..."
    git clone https://github.com/mikumi/dotfiles.git "$DOTFILES"
  fi
}

function installVundle() {
  if [ ! -d "~/.vim/bundle/Vundle.vim" ]; then
    echo "Installing Vundle plugin manager for VIM..."
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  fi
}

function installTPM() {
  if [ ! -d "~/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  fi
}

function installHyper() {
  mkdir -p ~/.hyper_plugins
  cd ~/.hyper_plugins
  ln -s ~/dotfiles/.hyper_plugins/local
  cd
}

function linkDotfiles() {
  cd $HOME
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
      ln -s $DOTFILES/$file
  done
  unset dotfiles file

  ln -s "$DOTFILES/bin"

  mkdir -p .gradle
  cd .gradle
  rm gradle.properties; ln -s "$DOTFILES/.gradle/gradle.properties"
  cd ~
}

main