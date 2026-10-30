# ~/.zshrc — minimalista, sem frameworks

# ── Homebrew (Mac Apple Silicon, Mac Intel e Linux/WSL) ──
for brew_path in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
  if [[ -x $brew_path ]]; then
    eval "$($brew_path shellenv)"
    break
  fi
done

# ── PATH ─────────────────────────────────────────────────
typeset -U path    # remove duplicatas automaticamente
path=(
  "$HOME/.local/bin"
  "$HOME/.cargo/bin"
  "$HOME/go/bin"
  $path
)

export CSTEST_DIR="/mnt/c/plugins/cstest-nvim"

# ── Histórico ────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

# ── Opções gerais ────────────────────────────────────────
setopt AUTO_CD
setopt INTERACTIVE_COMMENTS
setopt PROMPT_SUBST

# ── Autocomplete ─────────────────────────────────────────
if [[ -n $HOMEBREW_PREFIX ]]; then
  FPATH="$HOMEBREW_PREFIX/share/zsh/site-functions:$FPATH"
fi
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ── Teclas ───────────────────────────────────────────────
bindkey -e
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward

# ── Prompt estilo starship ───────────────────────────────
GIT_SYMBOL=' '    # precisa de Nerd Font; troque por '' se não tiver

git_info() {
  local out; out=$(git status --porcelain=v1 --branch 2>/dev/null) || return
  local -a l=("${(@f)out}")
  local b=${l[1]#\#\# } flags="" x s m u

  [[ $b == *"ahead "* ]]  && flags+="⇡"
  [[ $b == *"behind "* ]] && flags+="⇣"
  b=${b%%...*}; b=${b%% \[*}
  [[ $b == HEAD* ]] && b=$(git rev-parse --short HEAD 2>/dev/null)
  [[ $b == "No commits yet on "* ]] && b=${b##* }

  for x in "${(@)l[2,-1]}"; do
    [[ $x == '??'* ]] && { u=1; continue }
    [[ ${x[1]} != ' ' ]] && s=1
    [[ ${x[2]} != ' ' ]] && m=1
  done
  [[ -n $m ]] && flags="!$flags"
  [[ -n $s ]] && flags="+$flags"
  [[ -n $u ]] && flags="?$flags"

  print -n " on %B%F{magenta}${GIT_SYMBOL}${b//\%/%%}%f%b"
  [[ -n $flags ]] && print -n " %B%F{red}[${flags}]%f%b"
}

precmd() {
  local ret=$?
  GIT_PROMPT=$(git_info)
  PROMPT_CHAR_COLOR=$([[ $ret == 0 ]] && echo green || echo red)
  [[ -n $_prompt_started ]] && print     # linha em branco entre prompts
  _prompt_started=1
}

PROMPT='%B%F{green}%m%f%b in %B%F{cyan}%3~%f%b${GIT_PROMPT}
%B%F{${PROMPT_CHAR_COLOR}}❯%f%b '

# ── Aliases ──────────────────────────────────────────────
alias ls='ls --color=auto'
alias ll='ls -lah'
alias grep='grep --color=auto'

# ── Plugins (instalados via brew, carregados direto) ─────
if [[ -n $HOMEBREW_PREFIX ]]; then
  _zsh_autosuggest="$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  _zsh_highlight="$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

  [[ -f $_zsh_autosuggest ]] && source "$_zsh_autosuggest"
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

  # precisa ser o último source do arquivo
  [[ -f $_zsh_highlight ]] && source "$_zsh_highlight"

  unset _zsh_autosuggest _zsh_highlight
fi

# ── kiro-cli ai-jail ─────

kiro-cli-jail() {
	 ai-jail --allow-host kiro.dev --allow-host amazonaws.com -- kiro-cli --v3
}


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
