# Dotfiles Comprehensive Documentation & Resilient Scripts Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Transform the `terminal-dotfiles` repository into a completely portable, resilient, and beginner-friendly configuration system with automatic dependency/font installation, safe idempotency, and comprehensive documentation.

**Architecture:** 
1. Modernized `.zshrc` with dynamic paths and robust checks.
2. Idempotent `restore.sh` that detects OS package managers (`apt`, `dnf`, `pacman`, `brew`), installs missing CLI tools (`eza`, `zoxide`, `fzf`, `fnm`), downloads `MesloLGS NF` Nerd Fonts, safely updates existing plugins via Git, and creates timestamped backups.
3. Enhanced `backup.sh` for easy dotfiles packaging.
4. Comprehensive `README.md` containing full multi-distro setup instructions, manual commands, alias catalog, and troubleshooting guides.

**Tech Stack:** Bash, Zsh, Oh My Zsh, Powerlevel10k, Ghostty, eza, zoxide, fzf, fnm, MesloLGS NF.

## Global Constraints
- Scripts must be compatible with Bash on Linux and macOS.
- Idempotency is required: running `restore.sh` multiple times or on partially-configured systems must not fail.
- All user directory references must use `$HOME` instead of hardcoded paths.

---

### Task 1: Fix Portability and Theme Loading in `dotfiles/zshrc`

**Files:**
- Modify: `dotfiles/zshrc`

- [ ] **Step 1: Update `dotfiles/zshrc`**
Modify `dotfiles/zshrc` to:
1. Load `p10k.zsh` if it exists.
2. Set `ZSH_THEME="powerlevel10k/powerlevel10k"`.
3. Make Homebrew initialization conditional and multi-platform (`/home/linuxbrew/.linuxbrew` and `/opt/homebrew`).
4. Replace hardcoded `/home/danieldev/.local/share/fnm` with `$HOME/.local/share/fnm`.

- [ ] **Step 2: Syntax check `dotfiles/zshrc`**
Run: `zsh -n dotfiles/zshrc`
Expected: Exits with code 0 (no syntax errors).

- [ ] **Step 3: Commit changes**
```bash
git add dotfiles/zshrc
git commit -m "fix(zshrc): make paths portable and ensure p10k theme integration"
```

---

### Task 2: Implement Idempotent and Feature-Rich `restore.sh`

**Files:**
- Modify: `restore.sh`

- [ ] **Step 1: Implement the upgraded `restore.sh`**
The script will:
- Check for base tools (`git`, `curl`, `tar`).
- Detect package managers (`apt`, `dnf`, `pacman`, `brew`).
- Provide an interactive prompt (or `-y` / `--yes` flag) to install missing CLI tools (`eza`, `zoxide`, `fzf`).
- Offer automatic installation of `MesloLGS NF` Nerd Fonts to `~/.local/share/fonts` (Linux) or `~/Library/Fonts` (macOS) if missing.
- Install Oh My Zsh if missing (skipping if already installed).
- Clone or update (`git pull`) custom plugins and themes (`powerlevel10k`, `zsh-autosuggestions`, `zsh-syntax-highlighting`, `fzf-tab`).
- Backup existing configuration files with timestamps (`.bak_YYYYMMDD_HHMMSS`) before overwriting.
- Offer to change default shell to Zsh (`chsh -s $(which zsh)`).

- [ ] **Step 2: Validate `restore.sh` syntax and execution in dry-run/help mode**
Run: `bash -n restore.sh`
Expected: Exits with code 0.

- [ ] **Step 3: Test `restore.sh` execution**
Run: `bash restore.sh --help` (or standard non-destructive run).
Verify that it handles existing repositories and backups cleanly without crashing.

- [ ] **Step 4: Commit changes**
```bash
git add restore.sh
git commit -m "feat(restore): add idempotency, package manager detection and font installer"
```

---

### Task 3: Improve `backup.sh`

**Files:**
- Modify: `backup.sh`

- [ ] **Step 1: Update `backup.sh`**
Ensure `backup.sh` verifies source files, copies them cleanly to `dotfiles/`, and packages `terminal_backup.tar.gz` with clean console feedback.

- [ ] **Step 2: Test `backup.sh`**
Run: `bash backup.sh`
Expected: Creates `terminal_backup.tar.gz` and copies active configs without error.

- [ ] **Step 3: Commit changes**
```bash
git add backup.sh
git commit -m "feat(backup): improve backup script error handling and feedback"
```

---

### Task 4: Write Comprehensive `README.md`

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Rewrite `README.md` with complete documentation**
Include:
1. Overview & Stack architecture (Ghostty, Zsh, Oh My Zsh, Powerlevel10k, eza, zoxide, fzf, fnm).
2. Quickstart (Automatic restore via `./restore.sh` or `.tar.gz`).
3. Prerequisites & Manual installation commands table for:
   - Ubuntu / Debian / Mint
   - Fedora / RHEL
   - Arch Linux / Manjaro
   - macOS (Homebrew)
4. MesloLGS NF Font installation guide (curl/manual download + installation steps).
5. Comprehensive Alias & Productivity Cheat Sheet (Navigation, Git, modern ls with eza, zoxide smart cd, pnpm, Antigravity IDE).
6. Backup workflow (`./backup.sh`).
7. Troubleshooting & FAQ (Missing icons/fonts, default shell change, fzf keybindings, command not found).

- [ ] **Step 2: Review and verify links & markdown rendering**
Verify that all markdown formatting, tables, and code snippets are accurate and easy to read.

- [ ] **Step 3: Commit changes**
```bash
git add README.md
git commit -m "docs: add comprehensive dotfiles documentation and multi-distro guide"
```

---

### Task 5: End-to-End Verification

- [ ] **Step 1: Test `backup.sh` generation**
Run: `./backup.sh`
Verify: `terminal_backup.tar.gz` contains updated `restore.sh`, `README.md`, and `dotfiles/`.

- [ ] **Step 2: Run dry-run/syntax verification across all files**
Run: `zsh -n dotfiles/zshrc && bash -n restore.sh && bash -n backup.sh`
Expected: All exit with code 0.
