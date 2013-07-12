# Load npm_globals, add the default node into the path.
# source ~/.dotfiles/source/50_devel.sh

# Install Node.js.
# if [[ "$(type -P nave)" ]]; then
#  nave_stable="$(nave stable)"
#  if [[ "$(node --version 2>/dev/null)" != "v$nave_stable" ]]; then
#    e_header "Installing Node.js $nave_stable"
#    # Install most recent stable version.
#    nave install stable >/dev/null 2>&1
#  fi
#  if [[ "$(nave ls | awk '/^default/ {print $2}')" != "$nave_stable" ]]; then
#    # Alias the stable version of node as "default".
#    nave use default stable true
#  fi
#fi

# Load npm_globals, add the default node into the path, initialize rbenv.
# source ~/.dotfiles/source/50_devel.sh

# Install Npm modules.
#if [[ "$(type -P npm)" ]]; then
#  e_header "Updating Npm"
#  npm update -g npm
#
#  { pushd "$(npm config get prefix)/lib/node_modules"; installed=(*); popd; } > /dev/null
#  list="$(to_install "${npm_globals[*]}" "${installed[*]}")"
#  if [[ "$list" ]]; then
#    e_header "Installing Npm modules: $list"
#    npm install -g $list
#  fi
#fi

# Install RVM
if [[ ! "$(type -P rvm)" ]]; then
  e_header "Installing RVM"
  curl -L https://get.rvm.io | bash
  [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
fi

# Install Ruby.
if [[ "$(type -P rvm)" ]]; then
  versions=(1.9.3-p392 1.9.3-p194 1.9.2-p290)

  list="$(to_install "${versions[*]}" "$(rvm list strings)")"
  if [[ "$list" ]]; then
    e_header "Installing Ruby versions: $list"
    for version in $list; do rvm install "$version"; done
    [[ "$(echo "$list" | grep -w "${versions[0]}")" ]] && rvm --default use "${versions[0]}"
  fi
fi

# Install Gems.
if [[ "$(type -P gem)" ]]; then
  gems=(bundler awesome_print interactive_editor crack)

  list="$(to_install "${gems[*]}" "$(gem list | awk '{print $1}')")"
  if [[ "$list" ]]; then
    e_header "Installing Ruby gems: $list"
    gem install $list
  fi
fi

