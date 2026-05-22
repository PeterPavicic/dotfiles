#!/usr/bin/env bash
set -euo pipefail

current="$(powerprofilesctl get 2>/dev/null || true)"

case "$current" in
  balanced)     next="power-saver" ;;
  power-saver)  next="performance" ;;
  performance)  next="balanced" ;;
  *)            next="balanced" ;; # fallback if something unexpected happens
esac

powerprofilesctl set "$next"

# Optional: desktop notification (remove if you don't want it)
notify-send "Power profile" "Switched to: $next"
