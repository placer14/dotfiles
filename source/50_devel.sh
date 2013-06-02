# Manages dev folder jumping and setup
WORKDIR="/Users/mg/work/"
DROPBOX_WORK_PATH="/Users/mg/Dropbox/Work/"
function dev () {
  if [[ $# -gt 1 ]]; then
    echo "Usage: dev WORKSPACE_NAME"
    echo ""
    return 1
  fi
  if [[ -L ${WORKDIR}${1} ]]; then
    cd ${WORKDIR}${1}
    if [[ -f ${WORKDIR}${1}/.bashrc ]]; then
      . ${WORKDIR}${1}/.bashrc
    fi
  fi
}

function mkdev () {
  cd ${WORKDIR}
  if [[ $# -ne 2 ]]; then
    echo "Usage: mkworkspace ALIAS DROPBOX_WORK_FOLDER"
    echo ""
    return 1
  fi
  if [[ -L ${WORKDIR}${1} ]]; then
    echo "Workspace '${1}' already exists."
    echo ""
    return 1
  fi
  TARGET=${DROPBOX_WORK_PATH}${2}
  if [[ ! -d ${TARGET} ]]; then
    echo "Dropbox work folder '${2}' does not exist."
    read -p "Create it? [Y|n]" response
    case ${response} in
      [Yy]* ) mkdir ${DROPBOX_WORK_PATH}{$2}; break;;
      * ) ;;
    esac
  fi
  echo "Creating link..."
  ln -s ${TARGET} ${1}
  cd ${TARGET}
  echo "Creating startup script..."
  touch ./.bashrc
  echo "Creating ./docs..."
  mkdir ./docs
  echo "Creating ./src..."
  mkdir ./src
  dev ${1}
  echo "Setup complete."
  echo ""
}
