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

$env.PNPM_HOME = ($env.HOME | path join ".local/share/pnpm")
$env.PATH = ($env.PATH | append $env.PNPM_HOME)

# nvm: add the current node version's bin to PATH so tools like
# pnpm/npm/node (installed under nvm) are found in nushell.
# The default alias is often "node"/"lts/*" rather than a real version dir,
# so we resolve to the newest installed version.
$env.NVM_DIR = ($env.HOME | path join ".nvm")
let nvm_versions_dir = ($env.NVM_DIR | path join "versions/node")
if ($nvm_versions_dir | path exists) {
    let nvm_node_bin = (
        ls $nvm_versions_dir
        | where type == dir
        | get name
        | sort --natural
        | last
        | path join "bin"
    )
    if ($nvm_node_bin | path exists) {
        $env.PATH = ($env.PATH | prepend $nvm_node_bin)
    }
}


$env.PATH = (
    $env.PATH
    | prepend [
        $"($env.HOME)/.opencode/bin"
        $"($env.HOME)/.local/bin"
        $"($env.HOME)/.antigravity/antigravity/bin"
        $"($env.BUN_INSTALL)/bin"
        "/opt/homebrew/bin"
    ]
    | append [
        $"($env.ANDROID_HOME)/emulator"
        $"($env.ANDROID_HOME)/platform-tools"
    ]
    | uniq
)

source-env ~/.config/nushell-local.nu

$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'

mkdir $nu.cache-dir
carapace _carapace nushell | save --force $"($nu.cache-dir)/carapace.nu"

