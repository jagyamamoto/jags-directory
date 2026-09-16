#!/usr/bin/env bash
set -u

# Opens a file:// URL, Markdown link, localhost opener URL, or POSIX path in Finder.
# Automator text services usually pass selected text on stdin.

log="$HOME/Library/Logs/jags-directory-open.log"
mkdir -p "$(dirname "$log")"

input=""
if [ "$#" -gt 0 ]; then
  input="$*"
else
  input="$(cat 2>/dev/null || true)"
  if [ -z "$input" ]; then
    input="$(pbpaste 2>/dev/null || true)"
  fi
fi

{
  printf '\n[%s]\n' "$(date '+%Y-%m-%d %H:%M:%S')"
  printf 'input=%s\n' "$input"
} >>"$log"

resolve_path() {
  JAGS_DIRECTORY_TEXT="$1" osascript -l JavaScript -e '
ObjC.import("Foundation");

function trimToken(value) {
  return value
    .replace(/^[\s<>"'"'"'`]+/, "")
    .replace(/[\s<>"'"'"'`.,;:!?]+$/, "");
}

const env = $.NSProcessInfo.processInfo.environment;
let text = env.objectForKey("JAGS_DIRECTORY_TEXT").js || "";
text = text.replace(/\r/g, "\n").trim();

let candidate = "";

let markdown = text.match(/\]\(([^)]+)\)/);
if (markdown) candidate = markdown[1];

if (!candidate) {
  let fileUrl = text.match(/file:\/\/[^\s<>"'"'"')]+/);
  if (fileUrl) candidate = fileUrl[0];
}

if (!candidate) {
  let localUrl = text.match(/https?:\/\/127\.0\.0\.1:\d+\/open\?p=[^\s<>"'"'"')]+/);
  if (localUrl) candidate = localUrl[0];
}

if (!candidate) {
  let absolutePath = text.match(/(?:^|\s)(\/[^\n\r]+)/);
  if (absolutePath) candidate = absolutePath[1];
}

candidate = trimToken(candidate || text);

let path = "";
if (/^file:\/\//.test(candidate)) {
  const url = $.NSURL.URLWithString(candidate);
  if (url) path = url.path.js;
} else if (/^https?:\/\/127\.0\.0\.1:\d+\/open\?p=/.test(candidate)) {
  const match = candidate.match(/[?&]p=([^&]+)/);
  if (match) path = decodeURIComponent(match[1]);
} else {
  path = candidate.replace(/^~(?=\/)/, $.NSHomeDirectory().js);
}

path;
'
}

path="$(resolve_path "$input")"

{
  printf 'resolved=%s\n' "$path"
  if [ -n "$path" ] && [ -e "$path" ]; then
    printf 'exists=yes\n'
  else
    printf 'exists=no\n'
  fi
} >>"$log"

if [ -z "$path" ] || [ ! -e "$path" ]; then
  osascript -e 'display notification "Could not find the file or folder" with title "Jag'\''s directory" sound name "Basso"' >/dev/null 2>&1 || true
  exit 1
fi

if [ -d "$path" ]; then
  /usr/bin/open "$path"
else
  /usr/bin/open -R "$path"
fi

osascript -e 'display notification "Opened in Finder" with title "Jag'\''s directory" sound name "Glass"' >/dev/null 2>&1 || true
