#!/usr/bin/env bash
set -euo pipefail
mkdir -p "$HOME/Pictures/Screenshots"
filepath="$HOME/Pictures/Screenshots/Screenshot $(date '+%Y-%m-%d %H%M%S').png"

wp=""
p=""
unfreeze() {
  if [ -n "$wp" ]; then
    kill "$wp" 2>/dev/null || true
    wp=""
  fi
  if [ -n "$p" ]; then
    rm -f "$p"
    p=""
  fi
}
trap unfreeze EXIT

# Start wayfreeze and block until the screen is actually frozen
freeze() {
  p=$(mktemp -u).fifo
  mkfifo "$p"
  wayfreeze --hide-cursor --after-freeze-timeout 100 --after-freeze-cmd "echo > $p" &
  wp=$!
  read -r <"$p"
}

case "${1:-fullscreen}" in
fullscreen)
  freeze
  grim "$filepath"
  ;;
region)
  freeze
  g=$(slurp -d)
  [ -z "$g" ] && exit 1
  grim -g "$g" "$filepath"
  ;;
window)
  # query geometry BEFORE freezing, the freeze overlay may steal focus
  g=$(mmsg get focusing-client | jq -r 'select(.width) | "\(.x),\(.y) \(.width)x\(.height)"')
  [ -z "$g" ] && exit 1
  freeze
  grim -g "$g" "$filepath"
  ;;
*)
  echo "usage: ${0##*/} fullscreen|region|window" >&2
  exit 2
  ;;
esac

unfreeze # release the screen before waiting on the notification

wl-copy --type image/png <"$filepath"

# -A implies --wait: blocks until the notification is clicked or expires,
# and prints the action name ("default") if it was clicked
action=$(notify-send -a screenshot -i "$filepath" -A default=Annotate \
  "Screenshot" "Click to annotate" || true)

if [ "$action" = "default" ]; then
  satty --filename "$filepath" --output-filename "$filepath" \
    --actions-on-enter save-to-file --early-exit
  wl-copy --type image/png <"$filepath" # put the annotated version on the clipboard
fi
