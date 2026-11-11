#!/usr/bin/env bash
set -euo pipefail

# dismiss previous keyboard switching notifications
makoctl list -j | jq -r 'first(.[] | select(.category == "kbd-switch")) | .id' | xargs -r -n1 makoctl dismiss -n

# cycle keyboard language
mmsg dispatch switch_keyboard_layout &&
  notify-send -c kbd-switch -i input-keyboard -h boolean:transient:true '' \
    "$(mmsg get keyboardlayout | jq -r '.layout')"
