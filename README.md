# RHCSA Study Bot 🎯

> Automated daily exam prep for the Red Hat Certified System Administrator (EX200) exam — powered by Claude AI.

## What it does

Every time you open WSL, it generates a fresh RHCSA-focused practice session based on where you are in your studies. It rotates through real EX200 exam objectives and adapts difficulty over time:

| Days | Mode | Style |
|------|------|-------|
| 1–7  | Foundation | Concepts + key commands |
| 8–20 | Practice | Hands-on exam-style tasks |
| 21+  | Exam Simulation | Pass/fail graded, no hints |

Each session gives you:
- A concise summary of what the RHCSA exam expects on that topic
- Two realistic exam-style tasks (worded like the real EX200)
- The most common mistake that causes candidates to fail that objective
- A verify command to confirm your work

## Requirements

- Rocky Linux 9 or a RHEL 9 VM (see setup options below)
- [Claude Code CLI](https://claude.ai/code) installed and authenticated (`claude` in PATH)
- Node.js (for Claude CLI) — install via `nvm`

## VM Setup Options

### Option A — Rocky Linux 9 (free RHEL alternative, recommended)

1. Download the ISO: [rockylinux.org/download](https://rockylinux.org/download) — grab the **Minimal** ISO
2. Create a new VM in VirtualBox:
   - Type: **Linux**, Version: **Red Hat (64-bit)**
   - RAM: 2048 MB minimum
   - Disk: 20 GB
3. Boot from the ISO and follow the installer — set a root password and create a user
4. Once booted, install git:
   ```bash
   sudo dnf install -y git
   ```

### Option B — Official RHEL 9 VM (free developer subscription)

1. Register for a free Red Hat Developer account at [developers.redhat.com](https://developers.redhat.com)
2. Download the RHEL 9 DVD ISO
3. Create a VirtualBox VM with the same specs as above
4. During install, register with your Red Hat account to activate the free dev subscription

---

## Install Claude CLI on your VM

```bash
# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.bashrc

# Install Node and Claude CLI
nvm install --lts
npm install -g @anthropic-ai/claude-code

# Authenticate
claude
```

## Install the Study Bot

```bash
git clone git@github.com:Racee98/rhcsa-study.git ~/study_automation
chmod +x ~/study_automation/claude_rhcsa.sh
```

Add this to your `~/.bashrc`:

```bash
# RHCSA exam prep — auto-runs on login
if command -v claude >/dev/null 2>&1; then
  echo ""
  echo " RHCSA Grind — Let's get certified!"
  ~/study_automation/claude_rhcsa.sh | tee -a ~/study_automation/rhcsa_practice_log.txt
  echo ""
fi
```

Then reload:

```bash
source ~/.bashrc
```

## Files

| File | Description |
|------|-------------|
| `claude_rhcsa.sh` | Main RHCSA exam prep script |
| `claude_daily_general.sh` | Original general Linux sysadmin script (kept as backup) |

## Customizing topics

Open `claude_rhcsa.sh` and comment/uncomment topics in the `topics=()` array to match where you are in your course. Add new topics as you progress.

---

*Beta v0.1 — built for personal RHCSA EX200 exam prep*
