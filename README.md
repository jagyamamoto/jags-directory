# Jag's directory

Jag's directory is a small macOS Finder utility for people who need to give local file locations to AI tools such as Codex, ChatGPT, Claude, Gemini, or other agents.

The motivation is simple: when you ask an AI to read a local file, it is annoying to explain where the file is. Jag's directory adds Finder Quick Actions that copy stable `file://` links and open pasted file links back in Finder.

## What It Adds

- **Jag's directory: Copy file link**  
  Right-click a Finder file or folder and copy a `file:///...` link to the clipboard.

- **Jag's directory: Open file link in Finder**  
  Select a `file://` link, Markdown link, or local path in text and open/reveal it in Finder.

- **Jag's directory: Set modified date to now**  
  Optional helper for copied files: keep the creation date, but update the modified date to the current time.

## Install

```bash
git clone https://github.com/jagyamamoto/jags-directory.git
cd jags-directory
./install.sh
```

If macOS blocks execution, run:

```bash
chmod +x install.sh scripts/*.sh
./install.sh
```

The installer creates Automator Quick Actions in:

```text
~/Library/Services/
```

If the menu does not update immediately, restart Finder or log out and back in.

## Usage

### Copy a File Link

1. In Finder, right-click a file or folder.
2. Choose **Quick Actions** or **Services**.
3. Click **Jag's directory: Copy file link**.
4. Paste the result into an AI prompt, note, task, or document.

Example clipboard value:

```text
file:///Users/example/Documents/Project/report.pdf
```

### Open a File Link

1. Select a `file://` link or local path in text.
2. Right-click and choose **Services**.
3. Click **Jag's directory: Open file link in Finder**.

Folders are opened. Files are revealed in Finder.

### Update Modified Date After Copying

Finder sometimes keeps the copied file's old modified date. If you want the creation date to stay as the source date while the modified date becomes "now":

1. Select the copied file or folder in Finder.
2. Choose **Quick Actions** or **Services**.
3. Click **Jag's directory: Set modified date to now**.

This runs `touch -m`, so it changes only the modified date.

## Prompt for Codex or Another AI

Copy this prompt into Codex, Claude Code, or another local coding agent to install it for you:

```text
Please install Jag's directory on this Mac.

Goal:
- Add Finder right-click actions that copy a selected file or folder as a file:// link.
- Add a text service that opens a selected file:// link or local path in Finder.
- Do not move the mouse or take over the visible desktop.

Steps:
1. Check that Git is installed.
2. Clone https://github.com/jagyamamoto/jags-directory.git into a normal local projects folder, not Dropbox/iCloud/Google Drive/OneDrive.
3. Run chmod +x install.sh scripts/*.sh.
4. Run ./install.sh.
5. Verify that ~/Library/Services contains:
   - Jag's directory: Copy file link.workflow
   - Jag's directory: Open file link in Finder.workflow
   - Jag's directory: Set modified date to now.workflow
6. Tell me how to use the Finder menu items.
```

## Uninstall

```bash
./uninstall.sh
```

## Notes

- `file://` links are local. They open only on the Mac where the same path exists.
- The scripts do not upload files or send paths to any server.
- The open action writes a small debug log to `~/Library/Logs/jags-directory-open.log`.
- The project is intentionally plain shell plus built-in macOS tools.

## License

MIT
