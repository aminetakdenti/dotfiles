[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting fzf)
source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias e=nvim
alias vim=nvim
alias vi=nvim
alias cd=z
alias oc=opencode
alias lg=lazygit
alias gclonep='git clone git@github-personal:'
alias gclonew='git clone git@github-work:'


# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# ANDROID
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

# OPENCODE
export EDITOR=vim


# eval section
eval "$(zoxide init zsh)"

# opencode
export PATH=/Users/amine/.opencode/bin:$PATH
export PATH="$HOME/.local/bin:$PATH"

# Added by Antigravity
export PATH="/Users/amine/.antigravity/antigravity/bin:$PATH"

# bun completions
[ -s "/Users/amine/.bun/_bun" ] && source "/Users/amine/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# pnpm
export PNPM_HOME="/Users/amine-dcb/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end


_aicommit() {
  local cli="$1" model="$2"; shift 2
  local msg start end elapsed input_tokens output_tokens cost
  start=$EPOCHREALTIME

  local diff
  diff=$(git diff --cached)
  if [[ -z "$diff" ]]; then
    echo "Nothing staged to commit."
    return 1
  fi

  setopt local_options no_monitor
  local spinner_pid
  ( while true; do for s in '⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏'; do printf "\r\033[36m%s Generating commit message...\033[0m" "$s"; sleep 0.1; done; done ) &
  spinner_pid=$!
  disown $spinner_pid 2>/dev/null

  msg=$(echo "$diff" | "$cli" -p --model "$model" "$@" \
    --system-prompt 'You are a commit message generator. Given a git diff on stdin, output ONLY the commit message (no preamble, no code fences, no explanation). Follow these rules:
Subject line: max 72 chars, imperative mood
Use a conventional commit prefix when appropriate: feat:, fix:, refactor:, docs:, style:, test:, chore:, build:, ci:, perf:
If the change is non-trivial, add a blank line then a short body explaining what and why.')

  kill $spinner_pid 2>/dev/null
  wait $spinner_pid 2>/dev/null
  printf "\r\033[K"

  end=$EPOCHREALTIME
  elapsed=$(( int(($end - $start) * 1000) ))
  input_tokens=$(( ${#diff} / 4 ))
  output_tokens=$(( ${#msg} / 4 ))
  # Haiku: $0.80/1M input, $4.00/1M output
  cost=$(( (input_tokens * 80 + output_tokens * 400) ))
  echo "---"
  echo "Model  : $model"
  echo "Message: $msg"
  echo "Time   : ${elapsed}ms"
  echo "Tokens : ~${input_tokens} in / ~${output_tokens} out"
  echo "Cost   : ~\$$(printf '%.8f' $(( cost / 100000000.0 ))) USD"
  echo "---"
  echo "$msg" | git commit -F -
}

claudecommit() {
  _aicommit claude 'us.anthropic.claude-haiku-4-5-20251001-v1:0'
}

picommit() {
  _aicommit pi 'amazon-bedrock/us.anthropic.claude-haiku-4-5-20251001-v1:0' --no-tools
}

codexcommit() {
  local msg start end elapsed tmpfile
  start=$EPOCHREALTIME
  tmpfile=$(mktemp)

  local diff
  diff=$(git diff --cached)
  if [[ -z "$diff" ]]; then
    echo "Nothing staged to commit."
    return 1
  fi

  setopt local_options no_monitor
  local spinner_pid
  ( while true; do for s in '⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏'; do printf "\r\033[36m%s Generating commit message...\033[0m" "$s"; sleep 0.1; done; done ) &
  spinner_pid=$!

  echo "$diff" | codex exec -m 'gpt-5.4-mini' --sandbox read-only -o "$tmpfile" \
    'You are a commit message generator. Given the git diff on stdin, output ONLY the commit message (no preamble, no code fences, no explanation). Subject line: max 72 chars, imperative mood. Use a conventional commit prefix when appropriate: feat:, fix:, refactor:, docs:, style:, test:, chore:, build:, ci:, perf:. If the change is non-trivial, add a blank line then a short body explaining what and why.' > /dev/null 2>&1

  kill $spinner_pid 2>/dev/null
  wait $spinner_pid 2>/dev/null
  printf "\r\033[K"

  msg=$(cat "$tmpfile")
  rm -f "$tmpfile"

  end=$EPOCHREALTIME
  elapsed=$(( int(($end - $start) * 1000) ))
  echo "---"
  echo "Model  : gpt-5.4-mini"
  echo "Message: $msg"
  echo "Time   : ${elapsed}ms"
  echo "---"
  echo "$msg" | git commit -F -
}

