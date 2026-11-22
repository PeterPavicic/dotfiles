#!/usr/bin/env bash

# Link each file in other/mozilla-profile/ into every Firefox and Zen profile
# on this machine, at the same relative path (e.g. chrome/userChrome.css).
#
# Only these individual files are linked. The profile directories themselves
# hold per-machine state (prefs.js, extensions, toolbar layout, Zen's own
# chrome/ mods), so they are deliberately not managed by the repo.

set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
SOURCE_DIR="$SCRIPT_DIR/mozilla-profile"

# Directories that may contain a profiles.ini
PROFILE_ROOTS=(
  "$HOME/.config/mozilla/firefox" # Firefox (XDG location, newer installs)
  "$HOME/.mozilla/firefox"        # Firefox (legacy location)
  "$HOME/.config/zen"             # Zen (XDG location)
  "$HOME/.zen"                    # Zen (legacy location)
)

# Print "<IsRelative>\t<Path>" for every [Profile*] section of a profiles.ini
profileEntries () {
  awk -F= '
    /^\[/ {
      if (path != "") print rel "\t" path
      path = ""; rel = 1; inProfile = ($0 ~ /^\[Profile/)
      next
    }
    inProfile && $1 == "Path"       { path = substr($0, 6) }
    inProfile && $1 == "IsRelative" { rel = $2 }
    END { if (path != "") print rel "\t" path }
  ' "$1"
}

linkInto () {
  local profile="$1" src rel dest

  while IFS= read -r -d '' src; do
    rel="${src#"$SOURCE_DIR"/}"
    dest="$profile/$rel"

    if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
      echo "Symlink already exists: $dest -> $src"
      continue
    fi

    mkdir -p "$(dirname "$dest")"
    # An existing file is kept as <name>.~N~ rather than overwritten
    ln --symbolic --force --backup=numbered "$src" "$dest"
    echo "Created symlink: $dest -> $src"
  done < <(find "$SOURCE_DIR" -type f -print0)
}

found=0
for root in "${PROFILE_ROOTS[@]}"; do
  [[ -f "$root/profiles.ini" ]] || continue

  while IFS=$'\t' read -r isRelative path; do
    if [[ "$isRelative" == "1" ]]; then
      profile="$root/$path"
    else
      profile="$path"
    fi
    [[ -d "$profile" ]] || continue

    linkInto "$profile"
    found=1
  done < <(profileEntries "$root/profiles.ini")
done

if [[ "$found" == 0 ]]; then
  echo "No Firefox/Zen profiles found; start the browser once, then rerun."
fi
