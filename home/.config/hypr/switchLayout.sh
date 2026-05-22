#!/usr/bin/env bash
set -euo pipefail

mainKbd="$(hyprctl devices -j | jq -r '[.keyboards[] | select(.main==true)][0].name')"

# dismiss previous keyboard switching notifications
makoctl list -j | jq -r 'first(.[] | select(.category == "kbd-switch")) | .id' | xargs -r -n1 makoctl dismiss -n

# cycle keyboard language
hyprctl switchxkblayout "$mainKbd" next && \
notify-send -c kbd-switch -i input-keyboard -h boolean:transient:true '' \
"$(hyprctl devices -j | jq -r '[.keyboards[] | select(.main==true)][0].active_keymap')"
