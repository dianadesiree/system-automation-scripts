# PowerShell Automation Scripts

This directory contains PowerShell scripts for Windows system automation.

## 📜 Available Scripts

### 1. Backup Script (`backup_script.ps1`)
Automated backup solution with compression and rotation policies.

**Features:**
- Creates timestamped backups
- Optional compression (ZIP format)
- Automatic backup rotation (keeps only recent backups)
- Detailed logging
- Error handling

**Usage:**
```powershell
# Basic backup
.\backup_script.ps1 -SourcePath "C:\ImportantFiles" -DestinationPath "D:\Backups"

# With compression and custom retention
.\backup_script.ps1 -SourcePath "C:\ImportantFiles" -DestinationPath "D:\Backups" -Compress -MaxBackups 5

2. User Manager Script (user_manager.ps1)
[Coming Soon] Active Directory user management automation.

🔧 Requirements
Windows PowerShell 5.1 or PowerShell 7+

Appropriate execution policy (Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser)

📝 Notes
Run scripts with administrative privileges when needed

Check log files for detailed operation history


Crea `bash/README.md`:

```markdown
# Bash Automation Scripts

This directory contains Bash scripts for Linux/Unix system automation (compatible with WSL on Windows).

## 📜 Available Scripts

### 1. Git Automation (`git_automation.sh`)
Interactive script for automated Git operations.

**Features:**
- Repository status checking
- Auto-commit with timestamped messages
- Push/pull operations
- Branch management
- Color-coded output

**Usage:**
```bash
# Make script executable
chmod +x git_automation.sh

# Run in current directory
./git_automation.sh

# Specify repository path and branch
./git_automation.sh /path/to/repo main "Custom commit message"

2. Server Monitor Script (server_monitor.sh)
[Coming Soon] System resource monitoring and alerts.

🔧 Requirements
Bash 4.0+

Git (for git automation)

WSL (Windows Subsystem for Linux) for Windows users

📝 Notes
For Windows users, run these scripts in WSL or Git Bash

Ensure scripts have execute permissions (chmod +x script.sh)

