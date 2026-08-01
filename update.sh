#!/usr/bin/env bash
#
# update.sh — filter-aware Arch Linux package updater (yay)
#
# Replaces the manual flow of your old `update` alias:
#   1. refreshes package databases first (`yay -Sy`) so pacman/yay actually
#      know about the newest available versions
#   2. lists available updates for official repos (`pacman -Qu -n` + `expac`)
#      and AUR (`yay -Qua`), showing the age of each new version — the same
#      [Xd Yh] info your alias showed, collected automatically
#   3. keeps only packages that pass BOTH filters:
#        - name does not match any BLACKLIST glob (e.g. 'haskell*')
#        - new version is at least MIN_AGE_DAYS days old
#   4. prints the exact command `yay -S <only those packages>` and asks
#      before running it
#
# Usage:
#   ./update.sh          # print the command, then ask y/N before running
#   ./update.sh -y       # print the command and run it immediately
#   ./update.sh -h       # help
#
# Replace the fish alias with:
#   alias update '/home/calvo/code/scripts/update/update.sh'
#   funcsave update
#
# NOTE: by design this is a *partial* upgrade — packages younger than
# MIN_AGE_DAYS stay on their old version until they mature. If you ever want
# a full system upgrade instead, run `yay -Syu`.
#
# The AUR age bracket (`[1d2h]` etc.) is yay's "age of the new version":
# the time since the AUR package was last modified (yay's FormatAgeTag).
#
# Dependencies: yay, pacman, expac (from the `expac` package).

set -euo pipefail

# ─────────────────────────── Configuration ────────────────────────────────
MIN_AGE_DAYS=7              # only update packages whose new version is at least this old
BLACKLIST=('haskell*' 'android*')   # shell glob patterns matched against package names;
                            # e.g. BLACKLIST=('haskell*' 'linux*' 'nvidia*')

# ─────────────────────────── Options ──────────────────────────────────────
AUTO_RUN=0
case "${1:-}" in
  -y|--yes) AUTO_RUN=1 ;;
  -h|--help)
    cat <<'EOF'
Usage: update.sh [-y|--yes] [-h|--help]

Filter-aware Arch Linux package updater (yay):
  1. refresh package databases (yay -Sy)
  2. list available repo + AUR updates with the age of each new version
  3. keep only packages whose new version is >= MIN_AGE_DAYS days old
     and whose name does not match a BLACKLIST glob (e.g. haskell*)
  4. print the exact `yay -S <pkgs>` command and ask before running it

Options:
  -y, --yes   run the generated yay command without asking
  -h, --help  show this help
EOF
    exit 0
    ;;
esac

MIN_AGE_SECONDS=$((MIN_AGE_DAYS * 86400))
MIN_AGE_HOURS=$((MIN_AGE_DAYS * 24))

for cmd in yay pacman expac; do
  command -v "$cmd" >/dev/null 2>&1 || {
    echo "error: required command '$cmd' not found in PATH" >&2
    exit 1
  }
done

# ─────────────────────────── Helpers ──────────────────────────────────────
is_blacklisted() {          # $1 = package name
  local name=$1 pat
  for pat in "${BLACKLIST[@]:-}"; do
    [[ $name == $pat ]] && return 0
  done
  return 1
}

fmt_age() {                 # $1 = age in seconds -> "Xd Yh"
  printf '%dd %dh' $(( $1 / 86400 )) $(( ($1 % 86400) / 3600 ))
}

join_capped() {             # $1 = max items, rest = items -> ", "-joined, capped
  local max=$1 i=0 out=""
  shift
  local total=$#
  for x in "$@"; do
    if (( i == max )); then
      out+="... and $((total - max)) more"
      break
    fi
    if (( i > 0 )); then out+=", "; fi
    out+="$x"
    i=$((i + 1))
  done
  printf '%s' "$out"
}

if [[ -t 1 ]]; then
  C_HDR=$'\033[1;34m'; C_OK=$'\033[1;32m'; C_WARN=$'\033[1;33m'; C_DIM=$'\033[2m'; C_OFF=$'\033[0m'
else
  C_HDR=; C_OK=; C_WARN=; C_DIM=; C_OFF=
fi

now=$(date +%s)

# ─────────────────────────── 1. Refresh ───────────────────────────────────
echo "${C_HDR}==> [1/4] Refreshing package databases (yay -Sy) ...${C_OFF}"
yay -Sy

# ─────────────────────────── 2. Repo packages ─────────────────────────────
echo "${C_HDR}==> [2/4] Checking official repo updates ...${C_OFF}"
mapfile -t repo_pkgs < <(pacman -Qu -n | awk '{print $1}')

to_update=()
to_show=()
skip_black=()
skip_new=()
skip_other=()

if (( ${#repo_pkgs[@]} > 0 )); then
  while read -r name version build; do
    if [[ ! $build =~ ^[0-9]+$ ]]; then
      skip_other+=("$name (no build date)")
      continue
    fi
    age=$((now - build))
    if is_blacklisted "$name"; then
      skip_black+=("$name ($(fmt_age "$age"))")
    elif (( age < MIN_AGE_SECONDS )); then
      skip_new+=("$name ($(fmt_age "$age"))")
    else
      to_update+=("$name")
      to_show+=("$name $version (${C_OK}$(fmt_age "$age")${C_OFF})")
    fi
  done < <(expac -S --timefmt="%s" "%n %v %b" "${repo_pkgs[@]}")
else
  echo "  No official upgrades available."
fi

# ─────────────────────────── 3. AUR packages ──────────────────────────────
echo "${C_HDR}==> [3/4] Checking AUR updates ...${C_OFF}"
mapfile -t aur_lines < <(yay -Qua)

for line in "${aur_lines[@]:-}"; do
  [[ -z $line ]] && continue
  read -r name _old _arrow new age_bracket <<< "$line"

  # yay prints the age of the new version as [Nd], [NdYh], [Yh], [YhZm] or [Zm]
  hours=0
  if [[ $age_bracket =~ ^\[([0-9]+)d([0-9]+)h\]$ ]]; then
    hours=$(( BASH_REMATCH[1] * 24 + BASH_REMATCH[2] ))
  elif [[ $age_bracket =~ ^\[([0-9]+)d\]$ ]]; then
    hours=$(( BASH_REMATCH[1] * 24 ))
  elif [[ $age_bracket =~ ^\[([0-9]+)h([0-9]+)m\]$ ]]; then
    hours=${BASH_REMATCH[1]}
  elif [[ $age_bracket =~ ^\[([0-9]+)h\]$ ]]; then
    hours=${BASH_REMATCH[1]}
  elif [[ $age_bracket =~ ^\[([0-9]+)m\]$ ]]; then
    hours=0
  else
    skip_other+=("$name (unparsable age '${age_bracket:-?}')")
    continue
  fi

  if is_blacklisted "$name"; then
    skip_black+=("$name ($(fmt_age $((hours * 3600))))")
  elif (( hours < MIN_AGE_HOURS )); then
    skip_new+=("$name ($(fmt_age $((hours * 3600))))")
  else
    to_update+=("$name")
    to_show+=("$name $new (${C_OK}$(fmt_age $((hours * 3600)))${C_OFF})")
  fi
done

# ─────────────────────────── 4. Summary + command ─────────────────────────
echo
echo "${C_HDR}==> [4/4] Summary${C_OFF}"
echo "  Eligible (>= ${MIN_AGE_DAYS}d old, not blacklisted):"
if (( ${#to_show[@]} > 0 )); then
  printf '    %s\n' "${to_show[@]}"
else
  echo "    ${C_DIM}none${C_OFF}"
fi
if (( ${#skip_black[@]} > 0 )); then
  echo "  ${C_WARN}Skipped (blacklisted):${C_OFF} $(join_capped 8 "${skip_black[@]}")"
fi
if (( ${#skip_new[@]} > 0 )); then
  echo "  ${C_WARN}Skipped (younger than ${MIN_AGE_DAYS}d):${C_OFF} $(join_capped 8 "${skip_new[@]}")"
fi
if (( ${#skip_other[@]} > 0 )); then
  echo "  ${C_WARN}Skipped (unparsable):${C_OFF} $(join_capped 8 "${skip_other[@]}")"
fi

if (( ${#to_update[@]} == 0 )); then
  echo
  echo "Nothing eligible to update."
  exit 0
fi

echo
echo "Generated command:"
echo "  ${C_OK}yay -S ${to_update[*]}${C_OFF}"
echo

run_it() {
  echo "${C_HDR}==> Running:${C_OFF} yay -S ${to_update[*]}"
  yay -S "${to_update[@]}"
}

if (( AUTO_RUN )); then
  run_it
else
  read -r -p "Run this command now? [y/N] " ans
  case "$ans" in
    y|Y|yes) run_it ;;
    *) echo "Aborted — copy the command above to run it manually." ;;
  esac
fi
