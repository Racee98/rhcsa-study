#!/bin/bash
# --- Claude Daily Linux Practice ---

# Ensure nvm node is in PATH (needed for non-interactive shells / cron)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
export PATH="$HOME/.local/bin:$PATH"

# --- 60‑day learning rotation ---
topics=(
  "manage files from the command line"
  "create, view, and edit text files"
  "manage local users and groups"
  "control access to files"
  "monitor and manage Linux processes"
  #"control services and daemons"
  #"access remote systems using SSH"
  #"manage networking"
  #"install and update software"
  #"basic Linux commands and filesystem navigation"
  #"user and group management"
  #"permissions and ownership"
  #"packages and repositories (apt, dpkg, yum)"
  #"process monitoring and signals"
  #"systemd services and journalctl"
  #"cron jobs and automation"
  #"network configuration and troubleshooting (ip, ss, netstat)"
  #"firewall with ufw and iptables"
  #"disk management and LVM"
  #"bash scripting fundamentals"
  #"advanced scripting, awk, sed, grep pipelines"
  #"ssh, scp, rsync — remote management"
  #"log analysis and monitoring tools"
  #"performance tuning and resource limits"
  #"Docker and container basics"
)

# --- Track personal day count ---
if [ ! -f ~/.study_start ]; then
  date +%s > ~/.study_start  # create marker on first run
fi
start=$(cat ~/.study_start)
today=$(date +%s)
elapsed_days=$(( (today - start) / 86400 ))

# --- Pick topic in rotation ---
topic_count=${#topics[@]}
day_index=$(( elapsed_days % topic_count ))
topic=${topics[$day_index]}

# --- Difficulty progression by elapsed time ---
# 0‑29 days  → Beginner
# 30‑59 days → Intermediate
# 60+ days   → Advanced
difficulty="beginner"
if [ "$elapsed_days" -ge 30 ]; then difficulty="intermediate"; fi
if [ "$elapsed_days" -ge 60 ]; then difficulty="advanced"; fi

# --- Build Claude prompt ---
prompt="Generate three ${difficulty}-level Linux sysadmin practice exercises focused on ${topic}. \
Include realistic command-line tasks, one troubleshooting scenario, \
and one interview-style question. Provide hints but not direct answers."

echo "Today's Focus: ${topic^}  --  Difficulty: ${difficulty^}"
echo ""
claude -p "$prompt"
