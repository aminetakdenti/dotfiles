_git_ai_diff() {
  local MAX_FILES=25
  local MAX_FILE_LINES=120
  local MAX_TOTAL_CHARS=30000

  local EXCLUDES=(
    ':(exclude)package-lock.json'
    ':(exclude)pnpm-lock.yaml'
    ':(exclude)bun.lock'
    ':(exclude)yarn.lock'
    ':(exclude)dist/**'
    ':(exclude).next/**'
    ':(exclude)coverage/**'
    ':(exclude)build/**'
    ':(exclude)out/**'
  )

  local output=""
  local total=0

  output+="Repository changes\n"
  output+="==================\n\n"

  output+="Files:\n"
  output+="$(git diff --cached --name-status "${EXCLUDES[@]}")"
  output+="\n\n"

  output+="Statistics:\n"
  output+="$(git diff --cached --stat "${EXCLUDES[@]}")"
  output+="\n\n"

  local files
  files=("${(@f)$(git diff --cached --name-only "${EXCLUDES[@]}" | head -n "$MAX_FILES")}")

  local file

  for file in "${files[@]}"; do
    [[ -z "$file" ]] && continue

    local patch
    patch="$(git diff --cached --unified=2 -- "$file")"

    local lines
    lines=$(printf "%s" "$patch" | wc -l | tr -d ' ')

    if (( lines > MAX_FILE_LINES )); then
      patch="$(
        {
          printf "%s\n" "$patch" | head -n 60
          echo
          echo "... diff truncated (${lines} lines) ..."
          echo
          printf "%s\n" "$patch" | tail -n 60
        }
      )"
    fi

    local section
    section=$'\n'"===== ${file} ====="$'\n'
    section+="$patch"$'\n'

    if (( total + ${#section} > MAX_TOTAL_CHARS )); then
      output+=$'\n'"... remaining files omitted because prompt limit was reached ..."
      break
    fi

    output+="$section"
    (( total += ${#section} ))
  done

  print -r -- "$output"
}

_aicommit() {
  local cli="$1"
  local model="$2"
  shift 2

  local msg start end elapsed diff
  local input_tokens output_tokens cost

  start=$EPOCHREALTIME

  diff="$(_git_ai_diff)"

  if [[ -z "$diff" ]]; then
    echo "Nothing staged to commit."
    return 1
  fi

  setopt local_options no_monitor

  local spinner_pid

  (
    while true; do
      for s in '⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏'; do
        printf "\r\033[36m%s Generating commit message...\033[0m" "$s"
        sleep 0.1
      done
    done
  ) &
  spinner_pid=$!
  disown $spinner_pid 2>/dev/null

  msg=$(
    printf "%s" "$diff" |
      "$cli" \
        -p \
        --model "$model" \
        "$@" \
        --system-prompt '
You are an expert Git assistant.

The input contains:
- changed files
- git diff statistics
- truncated patches

Infer the overall intent of the changes.

Output ONLY the commit message.

Rules:

- Use Conventional Commits.
- Allowed prefixes:
  feat:
  fix:
  refactor:
  docs:
  style:
  test:
  chore:
  build:
  ci:
  perf:

- Subject <= 72 characters.
- Use imperative mood.
- If the change is substantial include a blank line followed by a concise body.
- Never mention that the diff was truncated.
'
  )

  kill $spinner_pid 2>/dev/null
  wait $spinner_pid 2>/dev/null
  printf "\r\033[K"

  end=$EPOCHREALTIME
  elapsed=$(( int(($end - $start) * 1000) ))

  input_tokens=$(( ${#diff} / 4 ))
  output_tokens=$(( ${#msg} / 4 ))
  cost=$(( input_tokens * 80 + output_tokens * 400 ))

  echo "---"
  echo "Model  : $model"
  echo "Message:"
  echo "$msg"
  echo
  echo "Time   : ${elapsed}ms"
  echo "Tokens : ~${input_tokens} in / ~${output_tokens} out"
  echo "Cost   : ~\$$(printf "%.8f" $(( cost / 100000000.0 ))) USD"
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
  local msg start end elapsed tmpfile diff

  start=$EPOCHREALTIME
  tmpfile=$(mktemp)

  diff="$(_git_ai_diff)"

  if [[ -z "$diff" ]]; then
    echo "Nothing staged to commit."
    rm -f "$tmpfile"
    return 1
  fi

  setopt local_options no_monitor

  local spinner_pid

  (
    while true; do
      for s in '⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏'; do
        printf "\r\033[36m%s Generating commit message...\033[0m" "$s"
        sleep 0.1
      done
    done
  ) &
  spinner_pid=$!

  printf "%s" "$diff" |
    codex exec \
      -m gpt-5.4-mini \
      --sandbox read-only \
      -o "$tmpfile" \
'You are an expert Git assistant.

The input contains summarized git changes.

Output ONLY the commit message.

Use Conventional Commits.
Subject <=72 characters.
Imperative mood.
If needed include a short body.' \
>/dev/null 2>&1

  kill $spinner_pid 2>/dev/null
  wait $spinner_pid 2>/dev/null
  printf "\r\033[K"

  msg=$(<"$tmpfile")
  rm -f "$tmpfile"

  end=$EPOCHREALTIME
  elapsed=$(( int(($end - $start) * 1000) ))

  echo "---"
  echo "Model  : gpt-5.4-mini"
  echo "Message:"
  echo "$msg"
  echo
  echo "Time   : ${elapsed}ms"
  echo "---"

  echo "$msg" | git commit -F -
}
