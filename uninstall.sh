#!/usr/bin/env bash
set -euo pipefail

rm -rf "$HOME/Library/Services/Jag's directory: Copy file link.workflow"
rm -rf "$HOME/Library/Services/Jag's directory: Open file link in Finder.workflow"
rm -rf "$HOME/Library/Services/Jag's directory: Set modified date to now.workflow"

/System/Library/CoreServices/pbs -update 2>/dev/null || true
/System/Library/CoreServices/pbs -flush 2>/dev/null || true

echo "Jag's directory Quick Actions were removed."
