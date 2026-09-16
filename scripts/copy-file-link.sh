#!/usr/bin/env bash
set -u

# Copies Finder-selected files or folders as file:// URLs.
# Automator should pass Finder items as arguments.

out=""

file_url_for_path() {
  JAGS_DIRECTORY_PATH="$1" JAGS_DIRECTORY_IS_DIR="$2" osascript -l JavaScript -e '
ObjC.import("Foundation");
const env = $.NSProcessInfo.processInfo.environment;
const path = env.objectForKey("JAGS_DIRECTORY_PATH").js;
const isDir = env.objectForKey("JAGS_DIRECTORY_IS_DIR").js === "1";
$.NSURL.fileURLWithPathIsDirectory(path, isDir).absoluteString.js;
'
}

append_unique() {
  local value="$1"
  case "$out" in
    "$value"|"$value"$'\n'*|*$'\n'"$value"|*$'\n'"$value"$'\n'*) ;;
    *)
      if [ -z "$out" ]; then
        out="$value"
      else
        out="${out}"$'\n'"${value}"
      fi
      ;;
  esac
}

if [ "$#" -eq 0 ]; then
  path="$(osascript -e 'tell application "Finder" to POSIX path of (target of front window as alias)' 2>/dev/null || true)"
  if [ -n "$path" ]; then
    append_unique "$(file_url_for_path "$path" 1)"
  fi
else
  for item in "$@"; do
    if [ -d "$item" ]; then
      append_unique "$(file_url_for_path "$item" 1)"
    else
      append_unique "$(file_url_for_path "$item" 0)"
    fi
  done
fi

printf '%s' "$out" | pbcopy

if [ -n "$out" ]; then
  osascript -e 'display notification "Copied file link" with title "Jag'\''s directory" sound name "Glass"' >/dev/null 2>&1 || true
else
  osascript -e 'display notification "No file or folder was selected" with title "Jag'\''s directory" sound name "Basso"' >/dev/null 2>&1 || true
fi
