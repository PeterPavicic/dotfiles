#!/usr/bin/env bash
set -euo pipefail

# dismiss previous keyboard switching notifications
makoctl list -j | jq -r 'first(.[] | select(.category == "layout-switch")) | .id' | xargs -r -n1 makoctl dismiss -n

# keep track of trackpad status
flag="${XDG_RUNTIME_DIR:-/tmp}/mango-trackpad-disabled"

# cycle keyboard language
mmsg dispatch toggle_trackpad_enable || exit 1

if [ -e "$flag" ]; then
  rm "$flag"
  notify-send -c layout-switch -i input-touchpad -h boolean:transient:true '' \
    "Trackpad enabled"
else
  : >"$flag"
  notify-send -c layout-switch -i input-touchpad-off -h boolean:transient:true '' \
    "Trackpad disabled"
fi
