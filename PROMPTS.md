# Copy-Paste Install Prompts

These prompts are written for beginners. Paste one of them into Codex or Claude Code on the Mac where you want to use Jag's directory.

## Codex Prompt

```text
Please install Jag's directory on this Mac.

What Jag's directory is:
- A small macOS Finder utility.
- It adds Finder right-click Quick Actions for copying local file/folder links.
- It helps me give exact local file paths to AI tools when I want an AI to read a file.

Important safety rules:
- Do not move the mouse, switch apps, switch Spaces, or take over the visible desktop.
- Use Terminal/CLI/file operations only.
- Do not clone into Dropbox, iCloud Drive, Google Drive, OneDrive, or any cloud-sync folder.
- If Git is not installed, tell me clearly what to install.

Install steps:
1. Choose a normal local projects folder, for example:
   ~/Projects
   If it does not exist, create it.
2. Clone the repository:
   https://github.com/jagyamamoto/jags-directory.git
3. Enter the repository folder.
4. Run:
   chmod +x install.sh scripts/*.sh
5. Run:
   ./install.sh
6. Verify that these files now exist:
   ~/Library/Services/Jag's directory: Copy file link.workflow
   ~/Library/Services/Jag's directory: Open file link in Finder.workflow
   ~/Library/Services/Jag's directory: Set modified date to now.workflow
7. Run basic checks:
   bash -n install.sh
   bash -n uninstall.sh
   bash -n scripts/copy-file-link.sh
   bash -n scripts/open-file-link.sh
   bash -n scripts/touch-modified-now.sh
8. Explain to me, in simple Japanese, how to use the Finder menu items.

Expected user workflow:
- Finderでファイルやフォルダを右クリック
- Quick Actions または Services から "Jag's directory: Copy file link" を選ぶ
- AIへのプロンプトやメモに file:// リンクを貼る
- テキスト中の file:// リンクを選択して "Jag's directory: Open file link in Finder" を選ぶとFinderで開ける
```

## Claude Code Prompt

```text
Install Jag's directory on this Mac.

Repository:
https://github.com/jagyamamoto/jags-directory.git

Goal:
Set up Finder Quick Actions so I can right-click a local file/folder and copy a file:// link for AI prompts. This is useful because telling an AI where a local file lives is otherwise annoying.

Constraints:
- Work through shell/file operations.
- Do not control the visible desktop, mouse, keyboard, Spaces, or normal browser windows.
- Do not clone into Dropbox, iCloud Drive, Google Drive, OneDrive, or another cloud-sync folder.
- Prefer ~/Projects/jags-directory unless another normal local project folder already exists.
- Do not change unrelated system settings.

Please do:
1. Check whether git is available.
2. Create ~/Projects if needed.
3. Clone https://github.com/jagyamamoto/jags-directory.git into ~/Projects/jags-directory.
4. Run:
   cd ~/Projects/jags-directory
   chmod +x install.sh scripts/*.sh
   ./install.sh
5. Verify that these Automator Quick Actions were created:
   ~/Library/Services/Jag's directory: Copy file link.workflow
   ~/Library/Services/Jag's directory: Open file link in Finder.workflow
   ~/Library/Services/Jag's directory: Set modified date to now.workflow
6. Validate the shell scripts with bash -n.
7. Tell me the result and give me the simplest usage instructions in Japanese.

Usage instructions should include:
- Copy file link: Finderで対象を右クリック → Quick Actions/Services → Jag's directory: Copy file link
- Open file link: テキスト中の file:// リンクを選択 → Services → Jag's directory: Open file link in Finder
- Optional date fix: コピー後ファイルを選択 → Jag's directory: Set modified date to now
```

## Short Prompt

```text
Install Jag's directory from https://github.com/jagyamamoto/jags-directory.git on this Mac. Use CLI/file operations only, clone it into ~/Projects/jags-directory, run chmod +x install.sh scripts/*.sh, run ./install.sh, verify the three ~/Library/Services workflows were created, and explain the Finder right-click usage in simple Japanese.
```
