#!/usr/bin/env bash
set -euo pipefail

# dismiss previous keyboard switching notifications
makoctl list -j | jq -r 'first(.[] | select(.category == "layout-switch")) | .id' | xargs -r -n1 makoctl dismiss -n

get_layout() {
  local layoutShort="$(mmsg get all-monitors | jq -r '.monitors[] | select(.active==true) | .layout_symbol')"
  local layoutLong=""

  case "$layoutShort" in
  "T")
    layoutLong="Tile"
    ;;
  "S")
    layoutLong="Scroller"
    ;;
  "G")
    layoutLong="Grid"
    ;;
  "M")
    layoutLong="Monocle"
    ;;
  "K")
    layoutLong="Deck"
    ;;
  "CT")
    layoutLong="Tile (Center)"
    ;;
  "RT")
    layoutLong="Tile (Right)"
    ;;
  "VS")
    layoutLong="Scroller (Vertical)"
    ;;
  "VT")
    layoutLong="Tile (Vertical)"
    ;;
  "VG")
    layoutLong="Grid (Vertical)"
    ;;
  "VK")
    layoutLong="Deck (Vertical)"
    ;;
  "DW")
    layoutLong="Dwindle"
    ;;
  "F")
    layoutLong="Fair"
    ;;
  "VF")
    layoutLong="Fair (Vertical)"
    ;;
  *)
    layoutLong="Layout unknown"
    ;;
  esac

  echo "$layoutLong"
}

# cycle keyboard language
mmsg dispatch switch_layout &&
  notify-send -c layout-switch -i window -h boolean:transient:true '' \
    "$(get_layout)"
