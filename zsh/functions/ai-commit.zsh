_aicommit() {
  local cli="$1" model="$2"; shift 2
  local msg start end elapsed input_tokens output_tokens cost
  start=$EPOCHREALTIME

  local diff
  diff=$(git diff --cached)
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

  msg=$(echo "$diff" | "$cli" -p --model "$model" "$@" \
    --system-prompt 'You are a commit message generator. Given a git diff on stdin, output ONLY the commit message (no preamble, no code fences, no explanation). Follow these rules:
Subject line: max 72 chars, imperative mood
Use a conventional commit prefix when appropriate: feat:, fix:, refactor:, docs:, style:, test:, chore:, build:, ci:, perf:
If the change is non-trivial, add a blank line then a short body explaining what and why.')

  kill $spinner_pid 2>/dev/null
  wait $spinner_pid 2>/dev/null
  printf "\r\033[K"

  end=$EPOCHREALTIME
  elapsed=$(( int(($end - $start) * 1000) ))
  input_tokens=$(( ${#diff} / 4 ))
  output_tokens=$(( ${#msg} / 4 ))
  cost=$(( (input_tokens * 80 + output_tokens * 400) ))

  echo "---"
  echo "Model  : $model"
  echo "Message: $msg"
  echo "Time   : ${elapsed}ms"
  echo "Tokens : ~${input_tokens} in / ~${output_tokens} out"
  echo "Cost   : ~\$$(printf '%.8f' $(( cost / 100000000.0 ))) USD"
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
  local msg start end elapsed tmpfile
  start=$EPOCHREALTIME
  tmpfile=$(mktemp)

  local diff
  diff=$(git diff --cached)
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

  echo "$diff" | codex exec -m 'gpt-5.4-mini' --sandbox read-only -o "$tmpfile" \
    'You are a commit message generator. Given the git diff on stdin, output ONLY the commit message (no preamble, no code fences, no explanation). Subject line: max 72 chars, imperative mood. Use a conventional commit prefix when appropriate: feat:, fix:, refactor:, docs:, style:, test:, chore:, build:, ci:, perf:. If the change is non-trivial, add a blank line then a short body explaining what and why.' > /dev/null 2>&1

  kill $spinner_pid 2>/dev/null
  wait $spinner_pid 2>/dev/null
  printf "\r\033[K"

  msg=$(cat "$tmpfile")
  rm -f "$tmpfile"

  end=$EPOCHREALTIME
  elapsed=$(( int(($end - $start) * 1000) ))

  echo "---"
  echo "Model  : gpt-5.4-mini"
  echo "Message: $msg"
  echo "Time   : ${elapsed}ms"
  echo "---"

  echo "$msg" | git commit -F -
}
