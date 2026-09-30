# nvm.nu — minimal nvm shim for nushell.
#
# nvm proper is a bash function and can't be sourced into nushell. This
# provides the commands used day-to-day by manipulating $env.PATH directly,
# and delegates install/uninstall to the real nvm.sh run under bash.

def nvm-dir [] {
    $env.NVM_DIR? | default ($env.HOME | path join ".nvm")
}

def nvm-versions-dir [] {
    nvm-dir | path join "versions/node"
}

# All installed versions, natural-sorted (v24.16.0, v26.3.0, ...).
def nvm-installed [] {
    let d = (nvm-versions-dir)
    if ($d | path exists) {
        ls $d | where type == dir | get name | path basename | sort --natural
    } else {
        []
    }
}

# Resolve a user-supplied selector to an installed version dir name.
# Accepts: "lts" / "lts/*" / "default" / "node" -> newest installed,
# "24" / "v24" / "24.16" -> newest match, "v24.16.0" -> exact.
def nvm-resolve [selector: string] {
    let installed = (nvm-installed)
    if ($installed | is-empty) { return null }

    if ($selector in ["lts" "lts/*" "node" "default" "*" "latest"]) {
        return ($installed | last)
    }

    let want = (if ($selector | str starts-with "v") { $selector } else { $"v($selector)" })
    let exact = ($installed | where $it == $want)
    if not ($exact | is-empty) { return ($exact | last) }

    # prefix match: "v24" or "v24.16" -> newest v24.* / v24.16.*
    let matches = ($installed | where { |v| ($v == $want) or ($v | str starts-with $"($want).") })
    if ($matches | is-empty) { null } else { $matches | last }
}

# Strip any nvm node bin dirs from a PATH list.
def nvm-strip-path [paths: list<string>] {
    let vd = (nvm-versions-dir)
    $paths | where { |p| not ($p | str starts-with $vd) }
}

# Switch the active node version for this session.
export def --env "nvm use" [selector: string = "default"] {
    let resolved = (nvm-resolve $selector)
    if ($resolved == null) {
        print $"nvm: version '($selector)' not found. Installed: (nvm-installed | str join ', ')"
        return
    }
    let bin = (nvm-versions-dir | path join $resolved "bin")
    $env.PATH = (nvm-strip-path $env.PATH | prepend $bin)
    print $"Now using node ($resolved)"
}

# Print the node version currently on PATH.
export def "nvm current" [] {
    if (which node | is-empty) {
        print "none"
    } else {
        ^node --version
    }
}

# List installed versions, marking the active one.
export def "nvm list" [] {
    let active = (if (which node | is-empty) { "" } else { ^node --version | str trim })
    nvm-installed | each { |v| if ($v == $active) { $"* ($v)" } else { $"  ($v)" } } | str join "\n"
}
export alias "nvm ls" = nvm list

# Install / uninstall delegate to the real nvm under bash.
export def "nvm install" [version: string] {
    ^bash -c $". \"$NVM_DIR/nvm.sh\" && nvm install ($version)"
    print $"Installed. Run `nvm use ($version)` to activate in this session."
}

export def "nvm uninstall" [version: string] {
    ^bash -c $". \"$NVM_DIR/nvm.sh\" && nvm uninstall ($version)"
}
