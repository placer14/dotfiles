if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi
# Finished adapting your PATH environment variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"

