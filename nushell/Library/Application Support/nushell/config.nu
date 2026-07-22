# config.nu
#
# Installed by:
# version = "0.114.1"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings, 
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R

source scripts/tmx.nu
source scripts/ai-commit.nu

alias e = nvim
alias vim = nvim
alias vi = nvim
# alias cd = z
alias oc = ^opencode
alias lg = ^lazygit
alias gclonep = ^git clone git@github-personal:
alias gclonew = ^git clone git@github-work:

# Git aliases (oh-my-zsh git plugin style)
alias g = ^git
alias ga = ^git add
alias gaa = ^git add --all
alias gst = ^git status
alias gs = ^git status
alias gc = ^git commit
alias gcmsg = ^git commit -m
alias gco = ^git checkout
alias gcb = ^git checkout -b
alias gb = ^git branch
alias gba = ^git branch -a
alias gbd = ^git branch -d
alias gd = ^git diff
alias gds = ^git diff --staged
alias gp = ^git push
alias gpf = ^git push --force-with-lease
alias gl = ^git pull
alias glog = ^git log --oneline --decorate --graph
alias gloga = ^git log --oneline --decorate --graph --all
alias gm = ^git merge
alias grb = ^git rebase
alias grbi = ^git rebase -i
alias gsta = ^git stash
alias gstp = ^git stash pop
alias gstl = ^git stash list
alias gf = ^git fetch
alias gfa = ^git fetch --all --prune
alias gcl = ^git clone
alias gcp = ^git cherry-pick
alias grh = ^git reset HEAD
alias grhh = ^git reset HEAD --hard
alias gclean = ^git clean -fd

source ~/.cache/zoxide.nu
source ~/.cache/carapace.nu
source ~/.config/nushell-local.nu
