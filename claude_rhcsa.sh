#!/bin/bash
# --- Claude RHCSA Exam Prep ---

# Ensure nvm node is in PATH (needed for non-interactive shells / cron)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
export PATH="$HOME/.local/bin:$PATH"

# --- Official RHCSA EX200 Exam Objectives ---
topics=(
  "manage files from the command line"
  "create, view, and edit text files"
  "manage local users and groups"
  "control access to files"
  "monitor and manage Linux processes"
  #"understand and use essential tools: file redirection, grep, pipes, tar, gzip, find, locate"
  #"create simple shell scripts with loops, conditionals, and exit codes"
  #"operate running systems: boot targets, interrupt boot, identify processes, kill signals"
  #"start, stop, and check the status of network services with systemctl"
  #"manage local storage: list, create, delete partitions with fdisk and gdisk"
  #"create and configure file systems: ext4, xfs, mount, /etc/fstab, NFS mounts"
  #"configure and manage swap space"
  #"create and manage LVM: physical volumes, volume groups, logical volumes, resize"
  #"manage users and groups: useradd, usermod, groupadd, passwd, /etc/passwd, /etc/shadow"
  #"configure superuser access with sudo and /etc/sudoers"
  #"manage file permissions: chmod, chown, chgrp, umask, setuid, setgid, sticky bit"
  #"configure special permissions and ACLs with setfacl and getfacl"
  #"configure basic networking: ip, nmcli, hostnamectl, /etc/hosts, DNS resolution"
  #"configure firewalld: zones, services, ports, rich rules, permanent vs runtime"
  #"manage SELinux: modes, contexts, booleans, troubleshoot with ausearch and sealert"
  #"deploy and manage containers with podman: pull, run, inspect, volumes, systemd integration"
  #"schedule tasks with cron and at"
  #"manage software with dnf/yum: install, remove, update, repos, module streams"
  #"configure time synchronization with chronyc and timedatectl"
  #"archive, compress, and transfer files: tar, gzip, scp, rsync"
  #"configure SSH: key-based auth, sshd_config, ssh-keygen, ssh-copy-id"
  #"troubleshoot and repair the boot process: GRUB2, rd.break, root password reset"
  #"manage system journals and logs: journalctl, rsyslog, /var/log"
  #"configure autofs for automounting NFS shares"
  #"set container images to start automatically as systemd services"
)

# --- Track personal day count ---
if [ ! -f ~/.rhcsa_start ]; then
  date +%s > ~/.rhcsa_start
fi
start=$(cat ~/.rhcsa_start)
today=$(date +%s)
elapsed_days=$(( (today - start) / 86400 ))

# --- Pick topic in rotation ---
topic_count=${#topics[@]}
day_index=$(( elapsed_days % topic_count ))
topic=${topics[$day_index]}

# --- Exam-style difficulty progression ---
# 0-7 days   → Foundation (concept + basic commands)
# 8-20 days  → Practice (hands-on tasks like the real exam)
# 21+ days   → Exam Simulation (timed, no hints, graded)
mode="foundation"
mode_desc="Focus on understanding the concept and key commands."
if [ "$elapsed_days" -ge 8 ]; then
  mode="practice"
  mode_desc="Hands-on tasks. No spoon-feeding — work through it."
fi
if [ "$elapsed_days" -ge 21 ]; then
  mode="exam simulation"
  mode_desc="Timed exam-style. State whether the task would be graded pass/fail on the real EX200."
fi

# --- Build RHCSA-focused Claude prompt ---
prompt="You are an RHCSA exam coach preparing me for the Red Hat EX200 exam on RHEL 8/9.

Today's topic: ${topic}
Mode: ${mode^} — ${mode_desc}

Give me:
1. A concise summary of what the RHCSA exam expects me to know on this topic (bullet points, commands, config files).
2. Two realistic exam-style tasks I must complete from the command line, worded exactly how they might appear on the real exam.
3. One common mistake or gotcha that causes candidates to fail this objective.
4. A quick 'verify it worked' command I can run to confirm the task is complete.

Keep it practical. I want to pass the EX200, not just understand theory."

echo "=================================================="
echo " RHCSA Exam Prep  |  Day $((elapsed_days + 1))"
echo " Topic: ${topic%%:*}"
echo " Mode:  ${mode^}"
echo "=================================================="
echo ""
claude -p "$prompt"
