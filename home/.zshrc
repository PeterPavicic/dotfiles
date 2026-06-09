######## Path ########
export PATH="$HOME/.local/bin:$PATH:$HOME/go/bin"

######## Locale ######## 
export LANG=en_US.UTF-8

######## Editor ########
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi


######## History ########
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt append_history # append history (not overwrite)
setopt inc_append_history # append after execution
setopt share_history # share across sessions
setopt hist_ignore_all_dups # deduplicate
setopt hist_reduce_blanks # reduce blanks before writing to history

#### Autocomplete ####
setopt auto_menu
setopt menu_complete # autocmp first menu match
setopt autocd # type a dir to cd
setopt no_case_glob no_case_match # make cmp case insensitive
setopt globdots # include dotfiles
setopt extended_glob # match ~ # ^
setopt interactive_comments # allow comments in shell
unsetopt prompt_sp # don't autoclean blanklines
# stty stop undef # disable accidental ctrl s

######## Completion ########
autoload -Uz compinit && compinit
autoload -U colors && colors
# autoload -Uz tetris # main attraction of zsh, obviously

# place cursor at the end when searching history
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

# colors
eval "$(dircolors $HOME/.dircolors)"

zstyle ':completion:*' menu select # tab opens cmp menu
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # case-insensitive
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} # colorize cmp menu
setopt CORRECT # replaces ENABLE_CORRECTION

# make `/` character 'separate word', so it is not deleted with Ctrl-W
WORDCHARS=${WORDCHARS/\/}

######## fzf setup ########
source <(fzf --zsh) # allow for fzf history widget


######## Git prompt via vcs_info ######## 
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true

# Don't show staged/unstaged
zstyle ':vcs_info:*' stagedstr '%F%f' # staged changes
zstyle ':vcs_info:*' unstagedstr '%F%f' # unstaged changes

# # Show staged/unstaged
# zstyle ':vcs_info:*' stagedstr '%F{green}+%f' # staged changes
# zstyle ':vcs_info:*' unstagedstr '%F{yellow}!%f' # unstaged changes

# Dirty/clean indicator (replaces OMZ's ✗/✔)
function _git_indicator() {
  [[ -z "${vcs_info_msg_0_}" ]] && return
  local branch="${vcs_info_msg_0_}"
  if [[ $(git status --porcelain 2>/dev/null) ]]; then
    echo "%F{blue}${branch}%f %F{red}✗%f"
  else
    echo "%F{blue}${branch}%f %F{green}✔%f"
  fi
}

# Append %m to formats so the hook output shows up
zstyle ':vcs_info:git:*' formats '%F{blue}%b%f%c%u%m'
zstyle ':vcs_info:git:*' actionformats '%F{blue}%b%f|%F{red}%a%f%c%u%m'

precmd() { vcs_info }
setopt PROMPT_SUBST

PROMPT='%B%F{green}%n@%m%f%b:%F{blue}%~%f
$(_git_indicator) %B$%b '

######## Keybinds ######## 
# Vi mode
bindkey -v
export KEYTIMEOUT=10 # 100ms escape delay

# regular keybinds
bindkey -M viins '^W' backward-kill-word
bindkey -M viins '^U' backward-kill-line
bindkey -M viins '^?' backward-delete-char

# completion: Shift-Tab to go backwards
bindkey '\e[Z' reverse-menu-complete

# fzf
bindkey '^F' fzf-file-widget # additionally to Ctrl-T Ctrl-F also opens fzf-file-widget

# zle -N tetris
# bindkey '^T' tetris

# Ctrl-O to insert xdg-open
bindkey -r '^O'
bindkey -s '^O' 'xdg-open '
bindkey -M viins -s '^O' 'xdg-open '

# autocomplete using typed text, cursor at the end
bindkey '\e[A' history-beginning-search-backward-end
bindkey '\e[B' history-beginning-search-forward-end

# disable accidental ctrl s
stty stop undef

######## Aliases ######## 
source $HOME/.zsh_aliases

######## Plugins ######## 
_load_zsh_plugin() {
  local name=$1 f
  for f in \
    /usr/share/zsh/plugins/$name/$name.zsh \
    /usr/share/$name/$name.zsh \
    "$HOME/.config/zsh/plugins/$name/$name.zsh"
  do
    [[ -r $f ]] && { source "$f"; return 0; }
  done
  return 1
}

_load_zsh_plugin zsh-autosuggestions

# zoxide
eval "$(zoxide init --cmd cd zsh)"
# don't use zoxide in non-interactive sessions
[[ -n $CLAUDECODE ]] && export _ZO_DOCTOR=0

######## Local overrides######## 
[[ -f "$HOME/.localzshrc" ]] && source "$HOME/.localzshrc"

######## Match cursor to mode (normal/insert) ########
function zle-keymap-select zle-line-init {
  if [[ $KEYMAP == vicmd ]]; then
    echo -ne '\e[2 q' # block
  else
    echo -ne '\e[6 q' # beam
  fi
}

zle -N zle-keymap-select
zle -N zle-line-init
echo -ne '\e[6 q'  # default to beam on startup

# zsh syntax highlighting MUST be last
_load_zsh_plugin zsh-syntax-highlighting
