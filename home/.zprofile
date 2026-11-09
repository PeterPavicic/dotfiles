mkdir -p /tmp/aa

######## Path ########
# Set in the login profile so the graphical session gets it too
# (SDDM sources this, uwsm exports PATH into the session).
# `typeset -U` drops duplicates when nested login shells (e.g. tmux) re-source this.
typeset -U path PATH
path=("$HOME/.local/bin" $path "$HOME/go/bin")
export PATH

export SUDO_EDITOR=nvim
export EDITOR=nvim

[[ -f "$HOME/.zshprofile.local" ]] && source "$HOME/.zshprofile.local"
