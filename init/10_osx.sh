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
  brew update

  # Install Homebrew recipes.
  recipes=(git tree sl lesspipe id3tool nmap htop-osx man2html macvim)

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
