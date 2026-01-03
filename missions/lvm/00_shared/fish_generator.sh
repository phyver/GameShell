#!/usr/bin/env bash

gen_fishes() {
  local count="${1:-}"
  local dir="${2:-rivieres}"

  # Basic checks
  if [[ -z "$count" || ! "$count" =~ ^[0-9]+$ || "$count" -le 0 ]]; then
    echo "$(eval_gettext "Usage: gen_fishes <number> [dir]")"
    return 1
  fi

  mkdir -p "$dir"

  # Available species (just for choosing ASCII art)
  local -a species=(spike catfish roach)

  # Generate exactly <count> files total
  local i sp file
  for ((i=1; i<=count; i++)); do
    sp="${species[RANDOM % ${#species[@]}]}"
    file="$dir/poisson_$(printf '%03d' "$i").fish"
    case "$sp" in
      spike) cat > "$file" <<'EOF'
   _______
  /      /      
 /'''''\/ _    
/ @     \/ |  
>  _       |
\ <_)   /\_|
 \...../\
  \\____/
EOF
      ;;
      catfish) cat > "$file" <<'EOF'
                         _.'.__
                      _.'      .
':'.               .''   __ __  .
  '.:._          ./  _ ''     "-'.__
.'''-: """-._    | .                "-"._
 '.     .    "._.'                       "
    '.   "-.___ .        .'          .  :o'.
      |   .----  .      .           .'     (
       '|  ----. '   ,.._                _-'
        .' .---  |.""  .-:;.. _____.----'
        |   .-""""    |      '
      .'  _'         .'    _'
     |_.-'    -cat-   '-.'
EOF
      ;;
      roach) cat > "$file" <<'EOF'
      /`·.¸
     /¸...¸`:·
 ¸.·´  ¸   `·.¸.·´)
: © ):´;      ¸  {
 `·.¸ `·  ¸.·´\`·¸)
     `\\´´\¸.·´
EOF
      ;;
    esac
  done

  echo "$(eval_gettext "🐟 \$count fish created in '\$dir' (random ASCII per file).")"
}

gen_fishes "$@"
