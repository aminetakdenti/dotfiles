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

$env.config.edit_mode = "vi"
$env.config.show_banner = false

source scripts/tmx.nu
source scripts/ai-commit.nu
source scripts/git.nu
source scripts/nvm.nu
source ~/.cache/zoxide.nu
source $"($nu.cache-dir)/carapace.nu"

alias e = nvim
alias vim = nvim
alias vi = nvim
alias cd = z
alias oc = ^opencode
alias pi = ^pi --model amazon-bedrock/us.openai.gpt-6-sol
alias lg = ^lazygit
alias gclonep = ^git clone git@github-personal:
alias gclonew = ^git clone git@github-work:
alias gs = git status
alias gfa = git fetch --all --prune

def tmux_session [] {
  let session = (
    tmux list-sessions -F '#S'
    | lines
    | str join "\n"
    | ^fzf
  )

  if not ($session | is-empty) {
    if ($env.TMUX? | is-empty) {
      tmux attach-session -t $session
    } else {
      tmux switch-client -t $session
    }
  }
}

$env.config.keybindings = ($env.config.keybindings | append [
  {
    name: ctrl_escape_to_normal
    modifier: control
    keycode: escape
    mode: [vi_insert]
    event: { send: Esc }
  }
  {
    name: option_backspace
    modifier: alt
    keycode: backspace
    mode: [vi_insert]
    event: { edit: BackspaceWord }
  }
  {
    name: command_backspace
    modifier: super
    keycode: backspace
    mode: [vi_insert]
    event: { edit: Clear }
  }
  {
    name: ctrl_u_clear
    modifier: control
    keycode: char_u
    mode: [vi_insert]
    event: { edit: Clear }
  },
  {
    name: tmux_session
    modifier: control
    keycode: char_s
    mode: [vi_insert]
    event: {
      send: executehostcommand
      cmd: "tmux_session"
    }
  }
])
