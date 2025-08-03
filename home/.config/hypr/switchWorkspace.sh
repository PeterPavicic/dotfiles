#!/usr/bin/env bash

# TODO: Write script which shuffles between workspaces in order (./switchWorkspace.sh)


# WARNING: Below code is copy of ./brightness.sh
#
# # Usage: brightness.sh <+|-> [step%]
# dir="$1"
# # read step from 2nd arg (default to 10%)
# step="${2:-10%}"
#
# # strip “%” so we can do arithmetic
# step_val="${step%\%}"
#
# # get raw values
# curr_raw=$(brightnessctl get)
# max_raw=$(brightnessctl max)
#
# # compute current percent (integer)
# curr_pct=$(( curr_raw * 100 / max_raw ))
#
# if [[ "$dir" == "+" ]]; then
#   brightnessctl s "${step}%+"
# else
#   new_pct=$(( curr_pct - step_val ))
#   if (( new_pct < 1 )); then
#     brightnessctl s 1%
#   else
#     brightnessctl s "${step_val}%-"
#   fi
# fi
