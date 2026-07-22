# env.nu
#
# Installed by:
# version = "0.114.1"
#
# Previously, environment variables were typically configured in `env.nu`.
# In general, most configuration can and should be performed in `config.nu`
# or one of the autoload directories.
#
# This file is generated for backwards compatibility for now.
# It is loaded before config.nu and login.nu
#
# See https://www.nushell.sh/book/configuration.html
#
# Also see `help config env` for more options.
#
# You can remove these comments if you want or leave
# them for future reference.

$env.PATH = ($env.PATH | prepend "/opt/homebrew/bin")
source ~/.cache/starship/init.nu

$env.EDITOR = "nvim"

$env.ANDROID_HOME = $"($env.HOME)/Library/Android/sdk"
$env.BUN_INSTALL = $"($env.HOME)/.bun"
$env.PNPM_HOME = $"($env.HOME)/Library/pnpm"

$env.PATH = (
    $env.PATH
    | prepend [
        $"($env.HOME)/.opencode/bin"
        $"($env.HOME)/.local/bin"
        $"($env.HOME)/.antigravity/antigravity/bin"
        $"($env.BUN_INSTALL)/bin"
        $env.PNPM_HOME
        "/opt/homebrew/bin"
    ]
    | append [
        $"($env.ANDROID_HOME)/emulator"
        $"($env.ANDROID_HOME)/platform-tools"
    ]
    | uniq
)

source-env ~/.config/nushell-local.nu
