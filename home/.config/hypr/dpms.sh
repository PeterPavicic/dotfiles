#!/bin/sh
# Turn all monitors on or off on whichever compositor is running.
# Usage: dpms.sh on|off   (used by hypridle.conf, so hypridle works under Hyprland and Mango)
set -eu

case "${1:-}" in
  on | off) action=$1 ;;
  *)
    echo "usage: ${0##*/} on|off" >&2
    exit 2
    ;;
esac

case ":${XDG_CURRENT_DESKTOP:-}:" in
  *:Hyprland:*)
    hyprctl dispatch "hl.dsp.dpms({action = \"$action\"})"
    ;;
  *:mango:*)
    # Not tested yet: written from Mango's IPC docs and source
    # (`mmsg get all-monitors` returns {"monitors":[{"name":...}, ...]}).
    if [ "$action" = off ]; then dispatcher=sleep_monitor; else dispatcher=wakeup_monitor; fi
    mmsg get all-monitors | jq -r '.monitors[].name' | while read -r output; do
      mmsg dispatch "$dispatcher,$output"
    done
    ;;
  *)
    echo "${0##*/}: unsupported compositor '${XDG_CURRENT_DESKTOP:-}'" >&2
    exit 1
    ;;
esac
