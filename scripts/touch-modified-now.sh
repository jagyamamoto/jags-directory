#!/usr/bin/env bash
set -u

# Updates only the modified date of selected files/folders.
# The creation date is left unchanged.

changed=0
failed=0

for item in "$@"; do
  if [ -e "$item" ]; then
    if /usr/bin/touch -m "$item"; then
      changed=$((changed + 1))
    else
      failed=$((failed + 1))
    fi
  else
    failed=$((failed + 1))
  fi
done

if [ "$changed" -eq 0 ] && [ "$failed" -eq 0 ]; then
  osascript -e 'display notification "Select copied files in Finder first" with title "Jag'\''s directory" sound name "Basso"' >/dev/null 2>&1 || true
  exit 1
fi

osascript -e "display notification \"Updated ${changed} item(s)\" with title \"Jag's directory\"" >/dev/null 2>&1 || true
