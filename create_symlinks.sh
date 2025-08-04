#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status.
set -e

shopt -s dotglob

# directory of current script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
SOURCE_DIR="$SCRIPT_DIR/home/"

# list of excluded dirs
EXCLUDED=()


absolutePath () {
  realpath "$1"
}

# get relativePath compared to $HOME directory
# (./home here, $HOME for dotfiles)
relativePath () {
  realpath -s --relative-to="$SOURCE_DIR" "$1"
}

createSymlinks ()
{
  for f in "$@"; do
    # skip any excluded directories or files
    if [[ " ${EXCLUDED[@]} " =~ " ${f} " ]]; then
      echo "Skipping excluded entry: $f"
      continue
    fi

    # if .config directory, recurse into it
    if [[ -d "$f" && "$(basename "$f")" == ".config" ]]; then
      # cd into .config
      cd "$f" || { echo "Failed to enter $f"; exit 1; }
      createSymlinks *
      cd ".."
      continue
    fi

    local absPath="$(absolutePath $f)"
    local relPath="$(relativePath $absPath)"
    local originalPath="$HOME/$relPath"

    # if $originalPath not already symlink
    if [[ -L "$originalPath" ]]; then
      echo "Symlink already exists: $originalPath -> $absPath"
    else
      # if directory
      if [[ -d "$originalPath" ]]; then
        mv "$originalPath" "$originalPath~bkp"
        echo "Backed up contents of $originalPath"
        ln --symbolic "$absPath" "$originalPath"
      elif [[ -f "$originalPath" ]]; then
        ln --symbolic --backup=simple "$absPath" "$originalPath"
      fi
      echo "Created symlink: $originalPath -> $absPath"
    fi
done
}



# ------ EXECUTING ------
cd "$SOURCE_DIR"
createSymlinks *

shopt -u dotglob
exit 0
