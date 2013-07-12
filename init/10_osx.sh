# OSX-only stuff. Abort if not OSX.
[[ "$OSTYPE" =~ ^darwin ]] || return 1

# Some tools look for XCode, even though they don't need it.
# https://github.com/joyent/node/issues/3681
# https://github.com/mxcl/homebrew/issues/10245
if [[ ! -d "$('xcode-select' -print-path 2>/dev/null)" ]]; then
  sudo xcode-select -switch /usr/bin
fi

# Install Homebrew.
if [[ ! "$(type -P brew)" ]]; then
  e_header "Installing Homebrew"
  true | /usr/bin/ruby -e "$(/usr/bin/curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
fi

if [[ "$(type -P brew)" ]]; then
  e_header "Updating Homebrew"
  cd `brew --prefix`
  git fetch origin
  git reset --hard origin/master || sudo git reset --hard origin/master
  cd -

  brew update

  cd `brew --prefix`
  # Set homebrew to use the latest ack that is v1
  `brew versions ack 2>/dev/null | grep ^1 | head -n 1 | cut -d' ' -f2-`
  cd -

  # Install Homebrew recipes.
  recipes=(git tree sl lesspipe id3tool nmap htop-osx man2html macvim tmux ack gpg wemux)

  list="$(to_install "${recipes[*]}" "$(brew list)")"
  if [[ "$list" ]]; then
    e_header "Installing Homebrew recipes: $list"
    brew install $list
  fi

  if [[ ! "$(type -P gcc-4.2)" ]]; then
    e_header "Installing Homebrew dupe recipe: apple-gcc42"
    brew install https://raw.github.com/Homebrew/homebrew-dupes/master/apple-gcc42.rb
  fi
fi

# Install vim janus
if [[ "$(type -P vim)" ]]; then
  if [[ -d $HOME/.vim && "$(cd $HOME/.vim; git status 2> /dev/null)" ]]; then  
    e_header "Updating vim-janus"
    cd $HOME/.vim; rake
  else
    e_header "Installing vim-janus"
    curl -Lo- https://raw.github.com/carlhuda/janus/master/bootstrap.sh | bash
  fi
fi
