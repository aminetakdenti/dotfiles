# AI-assisted commit message generation, mirrors zsh/functions/ai-commit.zsh

def _git_ai_diff [] {
    let max_files = 20
    let max_hunks = 2
    let max_total_chars = 12000

    let excludes = [
        ':(exclude)package-lock.json'
        ':(exclude)pnpm-lock.yaml'
        ':(exclude)bun.lock'
        ':(exclude)yarn.lock'
        ':(exclude)dist/**'
        ':(exclude).next/**'
        ':(exclude)coverage/**'
        ':(exclude)build/**'
        ':(exclude)out/**'
        ':(exclude)*.min.js'
    ]

    mut out = "Repository changes\n==================\n\n"
    $out += "Files:\n"
    $out += (^git diff --cached --name-status ...$excludes | complete | get stdout)
    $out += "\n\n"
    $out += "Statistics:\n"
    $out += (^git diff --cached --stat ...$excludes | complete | get stdout)
    $out += "\n"

    let files = (
        ^git diff --cached --name-only ...$excludes
        | complete | get stdout
        | lines
        | first $max_files
    )

    mut total = 0

    for file in $files {
        if ($file | is-empty) { continue }
        if $total > $max_total_chars { break }

        $out += $"\n===== ($file) =====\n"

        let patch = (^git diff --cached --unified=1 -- $file | complete | get stdout)

        mut hunk = 0
        mut printing = false

        for line in ($patch | lines) {
            if ($line | str starts-with "@@") {
                $hunk += 1
                if $hunk > $max_hunks {
                    $out += "... additional hunks omitted ...\n"
                    break
                }
                $printing = true
                $out += $"\n($line)\n"
                continue
            }

            if not $printing { continue }
            if ($line | str starts-with "+++") or ($line | str starts-with "---") { continue }
            if ($line | str starts-with "+") or ($line | str starts-with "-") {
                $out += $"($line)\n"
                $total += ($line | str length) + 1

                if $total > $max_total_chars {
                    $out += "... prompt truncated ...\n"
                    break
                }
            }
        }
    }

    $out
}

def _spinner_start [] {
    job spawn {
        let frames = ['⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏']
        loop {
            for frame in $frames {
                print -n $"\r\e[36m($frame) Generating commit message...\e[0m"
                sleep 0.1sec
            }
        }
    }
}

def _spinner_stop [id: int] {
    job kill $id
    print -n "\r\e[K"
}

def _print_commit_summary [model: string, msg: string, elapsed_ms: int] {
    print "---"
    print $"Model  : ($model)"
    print "Message:"
    print $msg
    print ""
    print $"Time   : ($elapsed_ms)ms"
    print "---"
}

export def claudecommit [] {
    let model = "us.anthropic.claude-haiku-4-5-20251001-v1:0"
    let start = (date now)
    let diff = (_git_ai_diff)

    if ($diff | is-empty) {
        print "Nothing staged to commit."
        return
    }

    let spinner = (_spinner_start)
    let msg = ($diff | ^claude -p --model $model --system-prompt (
        "You are an expert Git assistant.\n\nThe input contains:\n- changed files\n- git diff statistics\n- truncated patches\n\nInfer the overall intent of the changes.\n\nOutput ONLY the commit message.\n\nRules:\n\n- Use Conventional Commits.\n- Allowed prefixes:\n  feat:\n  fix:\n  refactor:\n  docs:\n  style:\n  test:\n  chore:\n  build:\n  ci:\n  perf:\n\n- Subject <= 72 characters.\n- Use imperative mood.\n- If the change is substantial include a blank line followed by a concise body.\n- Never mention that the diff was truncated.\n"
    ) | complete | get stdout | str trim)
    _spinner_stop $spinner

    let elapsed = (((date now) - $start) / 1ms)
    _print_commit_summary $model $msg ($elapsed | into int)

    $msg | ^git commit -F -
}

export def picommit [] {
    let model = "amazon-bedrock/us.anthropic.claude-haiku-4-5-20251001-v1:0"
    let start = (date now)
    let diff = (_git_ai_diff)

    if ($diff | is-empty) {
        print "Nothing staged to commit."
        return
    }

    let spinner = (_spinner_start)
    let msg = ($diff | ^pi -p --model $model --no-tools --system-prompt (
        "You are an expert Git assistant.\n\nOutput ONLY the commit message.\n\nUse Conventional Commits.\nSubject <=72 characters.\nImperative mood.\nIf needed include a short body."
    ) | complete | get stdout | str trim)
    _spinner_stop $spinner

    let elapsed = (((date now) - $start) / 1ms)
    _print_commit_summary $model $msg ($elapsed | into int)

    $msg | ^git commit -F -
}

export def codexcommit [] {
    let model = "gpt-5.4-mini"
    let start = (date now)
    let diff = (_git_ai_diff)

    if ($diff | is-empty) {
        print "Nothing staged to commit."
        return
    }

    let tmpfile = (mktemp)
    let spinner = (_spinner_start)

    $diff | ^codex exec -m $model --sandbox read-only -o $tmpfile (
        "You are an expert Git assistant.\n\nThe input contains summarized git changes.\n\nOutput ONLY the commit message.\n\nUse Conventional Commits.\nSubject <=72 characters.\nImperative mood.\nIf needed include a short body."
    ) | complete

    _spinner_stop $spinner

    let msg = (open $tmpfile | str trim)
    rm -f $tmpfile

    let elapsed = (((date now) - $start) / 1ms)
    _print_commit_summary $model $msg ($elapsed | into int)

    $msg | ^git commit -F -
}
