xhost && clear
fastfetch

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk
# ~/.zshrc

eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit
autoload -U colors && colors

zinit cdreplay -q

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^f' forward-of-line
bindkey '^b' backward-char
bindkey '^d' delete-char-or-list # cierra ventana tambien
bindkey '^k' kill-whole-line
bindkey '^w' backward-kill-word







# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt autocd
setopt auto_param_slash
setopt interactive_comments
stty stop undef

# Completion styling
# zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# variables #
export EDITOR=micro
export VISUAL=micro 
export BROWSER=thorium-browser
export TERM=kitty
# export TERM=ghostty
export COLORTERM=truecolor
export MICRO_TRUECOLOR=1

# Alias
alias rm='trash-put'
alias cl='clear'
alias gc='git clone'
alias lz='lazygit'
alias yas='yay -S'
alias update='sudo pacman -Sy'
alias upgrade='sudo pacman -Syu'
alias install='sudo pacman -S'
alias remove='sudo pacman -R'
alias v='vim'
alias n='nvim'
alias r='ranger'
alias m='micro'
alias ls='lsd'
alias la='lsd -a --oneline'
alias ll='lsd -l'
alias lt='lsd -h --tree --depth 3'
alias lta='lsd -ha --tree --depth 3'
alias grep='grep --color=always'
alias cat='bat'
alias rate-mirrors='sudo rate-mirrors --disable-comments --top-mirrors-number-to-retest=5 --save /etc/pacman.d/mirrorlist --allow-root arch'
alias ff='fastfetch'
alias buscar='micro $(fzf --preview="bat --color=always {}")'
# alias la='exa -la --color=always --group-directories-first --icons --no-time --no-filesize'
# alias ls='exa --color=always --icons -G -s type -F'
# alias ll='exa --icons --color=always   -G  -a -s type -F'
# alias lt='exa -T --color=always --group-directories-first --icons'
# alias l.='exa -a | grep -E "^\."'

#Shell change
alias tobash='sudo chsh $USER -s /bin/bash && echo re-open terminal'
alias tozsh='sudo chsh $USER -s /bin/zsh && echo re-open terminal'
alias tofish='sudo chsh $USER -s /bin/fish && echo re-open terminal'
alias sozh='source .zshrc'
alias sosh='source .bashrc'

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"


# Created by `pipx` on 2023-08-08 21:51:31
export PATH="$PATH:/home/juancarlos/.local/bin"

# yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

source ~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh
