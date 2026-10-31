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
#   4. drops any candidate whose install would force a package that the
#      filters left behind to move anyway (see "Dependency guard" below)
#   5. prints the exact command `yay -S <only those packages>` and asks
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
# Anything that survives the filters still has to be installable *alone*.
# Step 4 removes candidates that would break or silently bypass the age
# filter, instead of letting pacman abort the whole transaction on them.
#
# The AUR age bracket (`[1d2h]` etc.) is yay's "age of the new version":
# the time since the AUR package was last modified (yay's FormatAgeTag).
#
# Dependencies: yay, pacman (incl. vercmp), expac (from the `expac` package).

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
  4. drop candidates that would force a filtered-out package to change:
     a dependency of the new version that is not installed and not being
     updated, or a kept package that pins the old version of a candidate
  5. print the exact `yay -S <pkgs>` command and ask before running it

Options:
  -y, --yes   run the generated yay command without asking
  -h, --help  show this help
EOF
    exit 0
    ;;
esac

MIN_AGE_SECONDS=$((MIN_AGE_DAYS * 86400))
MIN_AGE_HOURS=$((MIN_AGE_DAYS * 24))

for cmd in yay pacman vercmp expac; do
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
echo "${C_HDR}==> [1/5] Refreshing package databases (yay -Sy) ...${C_OFF}"
yay -Sy

# ─────────────────────────── 2. Repo packages ─────────────────────────────
echo "${C_HDR}==> [2/5] Checking official repo updates ...${C_OFF}"
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
      skip_black+=("$name (${C_OK}$(fmt_age "$age")${C_OFF})")
    elif (( age < MIN_AGE_SECONDS )); then
      skip_new+=("$name (${C_OK}$(fmt_age "$age")${C_OFF})")
    else
      to_update+=("$name")
      to_show+=("$name $version (${C_OK}$(fmt_age "$age")${C_OFF})")
    fi
  done < <(expac -S --timefmt="%s" "%n %v %b" "${repo_pkgs[@]}")
else
  echo "  No official upgrades available."
fi

# ─────────────────────────── 3. AUR packages ──────────────────────────────
echo "${C_HDR}==> [3/5] Checking AUR updates ...${C_OFF}"
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
    skip_black+=("$name (${C_OK}$(fmt_age $((hours * 3600)))${C_OFF})")
  elif (( hours < MIN_AGE_HOURS )); then
    skip_new+=("$name (${C_OK}$(fmt_age $((hours * 3600)))${C_OFF})")
  else
    to_update+=("$name")
    to_show+=("$name $new (${C_OK}$(fmt_age $((hours * 3600)))${C_OFF})")
  fi
done

# ─────────────────────── 4. Dependency guard ──────────────────────────────
# The age filter leaves packages behind, so a candidate can be uninstallable
# even though it passed the filter. Two rules run to a fixpoint and drop such
# candidates instead of letting pacman abort the whole transaction:
#
#   A. the candidate's new version needs something that is not installed and
#      that nothing in this run will provide. Either the provider is being
#      held back (poppler was too young for inkscape's new soname), or the
#      dependency does not exist yet. A brand-new dependency is left alone:
#      pacman installs it fresh, and there is no older version to respect.
#   B. a package we keep at its current version pins, by exact version or by
#      shared-library soname, something a candidate stops providing
#      (poppler-glib pins poppler=26.08.0). Upgrading that candidate would
#      break the kept package, so the candidate goes too.
#
# Dropping one package can make another uninstallable, hence the loop.
#
# Cost: one expac dump plus an index of every name/version/provides token on
# the system (~1.5s on a ~1500 package install), paid once per run.

declare -A inst_ver=() inst_deps=() inst_prov=()
while IFS='|' read -r n v d p; do
  inst_ver[$n]=$v; inst_deps[$n]=$d; inst_prov[$n]=$p
done < <(expac -Q '%n|%v|%D|%P')

declare -A new_ver=() new_deps=() new_prov=()
if (( ${#repo_pkgs[@]} > 0 )); then
  while IFS='|' read -r n v d p; do
    new_ver[$n]=$v; new_deps[$n]=$d; new_prov[$n]=$p
  done < <(expac -S '%n|%v|%D|%P' "${repo_pkgs[@]}" 2>/dev/null || true)
fi

# A dependency token is a plain name, a version pin (`foo=1.2`, `foo>=1.2`) or
# a soname (`libfoo.so=3-64`). Packages satisfy them through their name and
# their provides list; pins may be spelled with or without pkgrel, so both
# spellings are indexed.
pkg_tokens() {              # $1 = name, $2 = version, $3 = provides
  local name=$1 ver=$2 provides=$3 t
  printf '%s\n%s=%s\n%s=%s\n' "$name" "$name" "$ver" "$name" "${ver%-*}"
  for t in $provides; do printf '%s\n' "$t"; done
}

declare -A tok_inst=() tok_new=() soname_owner=()
for n in "${!inst_ver[@]}"; do
  while read -r t; do tok_inst[$t]+=" $n"; done \
    < <(pkg_tokens "$n" "${inst_ver[$n]}" "${inst_prov[$n]}")
  for t in ${inst_prov[$n]}; do
    if [[ $t =~ ^(.+\.so)= ]]; then soname_owner[${BASH_REMATCH[1]}]=$n; fi
  done
done
for n in "${!new_ver[@]}"; do
  while read -r t; do tok_new[$t]+=" $n"; done \
    < <(pkg_tokens "$n" "${new_ver[$n]}" "${new_prov[$n]}")
done

satisfied_installed() {     # $1 = dependency token; true if today's system has it
  local t=$1 base op ver rc
  [[ -n ${tok_inst[$t]:-} ]] && return 0
  [[ $t =~ ^([^=<>]+)(\>=|\<=|\>|\<)(.+)$ ]] || return 1
  base=${BASH_REMATCH[1]} op=${BASH_REMATCH[2]} ver=${BASH_REMATCH[3]}
  [[ -n ${inst_ver[$base]:-} ]] || return 1
  rc=$(vercmp "${inst_ver[$base]}" "$ver")
  case $op in
    '>')  [[ $rc -gt 0 ]] ;;
    '>=') [[ $rc -ge 0 ]] ;;
    '<')  [[ $rc -lt 0 ]] ;;
    '<=') [[ $rc -le 0 ]] ;;
    *)    return 1 ;;
  esac
}

declare -A candidate=() excluded=()
if (( ${#to_update[@]} > 0 )); then
  for p in "${to_update[@]}"; do candidate[$p]=1; done
fi

# Dependency tokens are word-split all over this section; disable pathname
# expansion so a token can never be mistaken for a glob.
set -f
rounds=0
while :; do
  rounds=$((rounds + 1))
  changed=0

  # B: every package we keep must still find what it pins
  for h in "${!inst_ver[@]}"; do
    [[ -n ${candidate[$h]:-} ]] && continue
    for t in ${inst_deps[$h]:-}; do
      [[ -n ${tok_inst[$t]:-} ]] || continue
      kept_provider=0       # another package still provides it -> nothing to do
      for p in ${tok_inst[$t]}; do
        [[ -z ${candidate[$p]:-} ]] && kept_provider=1
      done
      (( kept_provider )) && continue
      for p in ${tok_inst[$t]}; do
        [[ -n ${candidate[$p]:-} ]] || continue
        [[ " ${tok_new[$t]:-} " == *" $p "* ]] && continue
        unset "candidate[$p]"
        excluded[$p]="kept package $h still needs $t"
        changed=1
      done
    done
  done

  # A: every candidate must install without upgrading a kept package
  for c in "${!candidate[@]}"; do
    for t in ${new_deps[$c]:-${inst_deps[$c]:-}}; do
      satisfied_installed "$t" && continue
      available=0           # will another candidate of this run provide it?
      for p in ${tok_new[$t]:-}; do
        [[ -n ${candidate[$p]:-} ]] && available=1
      done
      (( available )) && continue
      base=${t%%=*}
      if [[ $base == *.so ]]; then provider=${soname_owner[$base]:-}; else provider=$base; fi
      [[ -n ${inst_ver[$provider]:-} ]] || continue   # brand-new dependency
      unset "candidate[$c]"
      excluded[$c]="needs $t, which $provider only provides once it is updated"
      changed=1
      break
    done
  done

  (( changed )) || break
  (( rounds > 100 )) && break     # safety net: each round drops at least one package
done
set +f

if (( ${#excluded[@]} > 0 )); then
  kept_update=() kept_show=()
  for i in "${!to_update[@]}"; do
    p=${to_update[$i]}
    [[ -n ${excluded[$p]:-} ]] && continue
    kept_update+=("$p")
    kept_show+=("${to_show[$i]}")
  done
  to_update=(); to_show=()
  if (( ${#kept_update[@]} > 0 )); then
    to_update=("${kept_update[@]}")
    to_show=("${kept_show[@]}")
  fi
fi

# ─────────────────────────── 5. Summary + command ─────────────────────────
echo
echo "${C_HDR}==> [5/5] Summary${C_OFF}"
if (( ${#BLACKLIST[@]} > 0 )); then
  echo "  ${C_WARN}Blacklist keys (${#BLACKLIST[@]}):${C_OFF} $(join_capped 20 "${BLACKLIST[@]}")"
fi
if (( ${#skip_black[@]} > 0 )); then
  echo "  ${C_WARN}Skipped (blacklisted):${C_OFF} $(join_capped 8 "${skip_black[@]}")"
fi
if (( ${#skip_new[@]} > 0 )); then
  echo "  ${C_WARN}Skipped (younger than ${MIN_AGE_DAYS}d):${C_OFF}"
  printf '    %s\n' "${skip_new[@]}"
fi
if (( ${#skip_other[@]} > 0 )); then
  echo "  ${C_WARN}Skipped (unparsable):${C_OFF} $(join_capped 8 "${skip_other[@]}")"
fi
if (( ${#excluded[@]} > 0 )); then
  echo "  ${C_WARN}Excluded (dependency not updated in this run):${C_OFF}"
  mapfile -t _excl_names < <(printf '%s\n' "${!excluded[@]}" | sort)
  for p in "${_excl_names[@]}"; do
    echo "    $p (${excluded[$p]})"
  done
fi
echo "  ${C_WARN}Eligible (>= ${MIN_AGE_DAYS}d old, not blacklisted):${C_OFF}"
if (( ${#to_show[@]} > 0 )); then
  printf '    %s\n' "${to_show[@]}"
else
  echo "    ${C_DIM}none${C_OFF}"
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
