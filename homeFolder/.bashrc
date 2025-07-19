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
alias mt="cd /home/peter/WU_OneDrive/QFin/MT\ Master\ Thesis/"
alias obs="cd /home/peter/WU_OneDrive/obsidian/"
alias qf="cd /home/peter/WU_OneDrive/QFin/"
alias qfin="cd /home/peter/WU_OneDrive/QFin/"
alias thesis="cd /home/peter/WU_OneDrive/QFin/MT\ Master\ Thesis/"
alias wu="cd /home/peter/WU_OneDrive"
alias nvimdiff="nvim -d"

# export MOZ_ENABLE_WAYLAND=1
# export GDK_BACKEND=x11,wayland


# export CUDA_VISIBLE_DEVICES=-1
# export TF_ENABLE_ONEDNN_OPTS=1
