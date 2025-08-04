#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
# PS1='[\u@\h \W]\$ '

# My own edits
PS1='\[\e[1;32m\]\u@\h \[\e[1;34m\]\W\[\e[m\] \$ '
# PS1='\[\e[1;32m\]\u@\h \[\e[1;34m\]\w\[\e[0m\] \$ '
export EDITOR=nvim

# TODO:  Remove links to WU_OneDrive
alias nvimdiff="nvim -d"
alias obs="cd ~/obsidian/"
alias wu="cd ~/WU_OneDrive"
alias qf="cd ~/WU_OneDrive/QFin/"
alias qfin="cd ~/WU_OneDrive/QFin/"
alias thesis="cd ~/WU_OneDrive/QFin/MT\ Master\ Thesis/"
alias mt="cd ~/WU_OneDrive/QFin/MT\ Master\ Thesis/"
 
# export MOZ_ENABLE_WAYLAND=1
# export GDK_BACKEND=x11,wayland


# export CUDA_VISIBLE_DEVICES=-1
# export TF_ENABLE_ONEDNN_OPTS=1
