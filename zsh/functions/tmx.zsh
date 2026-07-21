tmx() {
    local root="$PWD"
    local base
    base=$(basename "$root")
    base=${base// /-}

    local session="$base"
    local i=1

    while tmux has-session -t "$session" 2>/dev/null; do
        session="${base}-${i}"
        ((i++))
    done

    tmuxinator start default \
        session_name="$session" \
        root="$root"
}
