# lazy load nvm
# all props goes to http://broken-by.me/lazy-load-nvm/
# grabbed from reddit @ https://www.reddit.com/r/node/comments/4tg5jg/lazy_load_nvm_for_faster_shell_start/

lazynvm() {
  echo "Lazy loading NVM..."
  unset -f nvm node npm npx
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
  [ -s "$BREW_PREFIX/opt/nvm/nvm.sh" ] && . "$BREW_PREFIX/opt/nvm/nvm.sh"  # This loads nvm ]
  [ -s "$BREW_PREFIX/opt/nvm/etc/bash_completion" ] && . "$BREW_PREFIX/opt/nvm/etc/bash_completion" ] # This loads nvm bash_completion
}

nvm() {
  lazynvm
  nvm $@
}

node() {
  lazynvm
  node $@
}

npm() {
  lazynvm
  npm $@
}

npx() {
  lazynvm
  npx $@
}
