# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Keybindings
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey -v

# Exports
export EDITOR="nvim"
export TERMINAL="kitty"
export BROWSER="google-chrome"
export DOTFILES="$HOME/.dotfiles"

export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
export MANPAGER='nvim +Man!'
export ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
export GOPATH=$HOME/go
export XDG_CURRENT_DESKTOP="Wayland"
export BAT_THEME=tokyonight_night 
export MANPAGER='nvim +Man!'
export MANWIDTH=999
export PATH="$HOME/.local/bin":$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/.local/share/go/bin:$PATH
export PATH="$GEM_HOME/bin:$PATH"


# brew
source "$HOME/.cargo/env"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Plugins
## Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then 
    mkdir -p "$(dirname $ZINIT_HOME)"
    echo "Downloading Zinit..."
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
    echo "Zinit downloaded"
fi

source "${ZINIT_HOME}/zinit.zsh"

## To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
zinit ice depth=1; zinit light romkatv/powerlevel10k

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

## Third party
zinit light zsh-users/zsh-completions 
zinit light zsh-users/zsh-autosuggestions 
zinit light zsh-users/zsh-syntax-highlighting
zinit light Aloxaf/fzf-tab
zinit light jeffreytse/zsh-vi-mode

## Add in snippets
zinit snippet OMZP::command-not-found

## Load completions
autoload -Uz compinit && compinit
zinit cdreplay -q

# Aliases
alias k="kubectl"
alias nvimrc="cd ${DOTFILES}/nvim/.config/nvim/ && ${EDITOR:-vim}"
alias zshrc="cd ${DOTFILES}/zsh/ && ${EDITOR:-vim} .zshrc"
alias dotrc="cd ${DOTFILES}/ && ${EDITOR:-vim} ."

if [[ $TERM == "xterm-kitty" ]]; then
	  alias ssh="kitten ssh"
fi

if command -v bat &> /dev/null; then
	alias cat="bat -pp" 
	alias catt="bat"
fi

if command -v eza &> /dev/null; then
	alias ls="eza --color=always --git --icons=always --sort=type \"\$@\""
fi

# History
HISTFILE=~/.histfile
HISTSIZE=1000
export HISTTIMEFORMAT="%F %T "
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS


# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else batcat -n --color=always --line-range :500 {}; fi"
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# completion settings
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# fzf
# https://github.com/josean-dev/dev-environment-files/blob/main/.zshrc
eval "$(fzf --zsh)"

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
--color=fg:#c0caf5,bg:#1a1b26,hl:#ff9e64 \
--color=fg+:#c0caf5,bg+:#292e42,hl+:#ff9e64 \
--color=info:#7aa2f7,prompt:#7dcfff,pointer:#7dcfff \
--color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# zioxide
if (( $+commands[zoxide] )); then
  eval "$(zoxide init --cmd cd zsh)"
else
  echo 'zoxide: command not found, please install it from https://github.com/ajeetdsouza/zoxide'
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if [ -f ~/.nimble.zsh ]; then
    source ~/.nimble.zsh
fi
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"
