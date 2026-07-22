# Start (or attach to) a tmuxinator session named after the current directory.
def tmx [] {
    let root = (pwd)
    let base = ($root | path basename | str replace -a " " "-")

    mut session = $base
    mut i = 1

    while (^tmux has-session -t $session | complete | get exit_code) == 0 {
        $session = $"($base)-($i)"
        $i += 1
    }

    ^tmuxinator start default $"session_name=($session)" $"root=($root)"
}
