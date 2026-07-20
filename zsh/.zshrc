[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  fast-syntax-highlighting
  fzf
)

source "$ZSH/oh-my-zsh.sh"

path_prepend() {
  [[ -d "$1" ]] || return 0
  case ":$PATH:" in
    *":$1:"*) ;;
    *) export PATH="$1:$PATH" ;;
  esac
}

path_append() {
  [[ -d "$1" ]] || return 0
  case ":$PATH:" in
    *":$1:"*) ;;
    *) export PATH="$PATH:$1" ;;
  esac
}

alias e='nvim'
alias vim='nvim'
alias vi='nvim'
alias cd='z'
alias oc='opencode'
alias lg='lazygit'
alias gclonep='git clone git@github-personal:'
alias gclonew='git clone git@github-work:'

export EDITOR="nvim"

export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"

export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

export ANDROID_HOME="$HOME/Library/Android/sdk"
path_append "$ANDROID_HOME/emulator"
path_append "$ANDROID_HOME/platform-tools"

export BUN_INSTALL="$HOME/.bun"
[[ -s "$BUN_INSTALL/_bun" ]] && source "$BUN_INSTALL/_bun"

export PNPM_HOME="$HOME/Library/pnpm"

path_prepend "$HOME/.opencode/bin"
path_prepend "$HOME/.local/bin"
path_prepend "$HOME/.antigravity/antigravity/bin"
path_prepend "$BUN_INSTALL/bin"
path_prepend "$PNPM_HOME"

eval "$(zoxide init zsh)"

source "$HOME/dotfiles/zsh/functions/ai-commit.zsh"

source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# bun completions
[ -s "/Users/amine-dcb/.bun/_bun" ] && source "/Users/amine-dcb/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
