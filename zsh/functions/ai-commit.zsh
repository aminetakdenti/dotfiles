_git_ai_diff() {
  local MAX_FILES=20
  local MAX_HUNKS=2
  local MAX_TOTAL_CHARS=12000

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
    ':(exclude)*.min.js'
  )

  local out=""
  local total=0

  out+="Repository changes\n"
  out+="==================\n\n"

  out+="Files:\n"
  out+="$(git diff --cached --name-status "${EXCLUDES[@]}")"
  out+="\n\n"

  out+="Statistics:\n"
  out+="$(git diff --cached --stat "${EXCLUDES[@]}")"
  out+="\n"

  local files
  files=("${(@f)$(
    git diff --cached --name-only "${EXCLUDES[@]}" |
      head -n "$MAX_FILES"
  )}")

  local file

  for file in "${files[@]}"; do
    [[ -z "$file" ]] && continue

    out+=$'\n'
    out+="===== $file ====="
    out+=$'\n'

    local patch
    patch=$(git diff --cached --unified=1 -- "$file")

    local hunk=0
    local printing=0

    while IFS= read -r line; do
      if [[ "$line" == @@* ]]; then
        ((hunk++))

        if ((hunk > MAX_HUNKS)); then
          echo "... additional hunks omitted ..."
          break
        fi

        printing=1
        echo
        echo "$line"
        continue
      fi

      ((printing)) || continue

      case "$line" in
        +*|-*)
          [[ "$line" == "+++"* || "$line" == "---"* ]] && continue
          echo "$line"
          ;;
      esac
    done <<<"$patch" >> >(while read -r l; do
      (( total += ${#l} + 1 ))

      if (( total > MAX_TOTAL_CHARS )); then
        echo
        echo "... prompt truncated ..."
        break
      fi

      out+="$l"$'\n'
    done)

    (( total > MAX_TOTAL_CHARS )) && break
  done

  print -r -- "$out"
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
