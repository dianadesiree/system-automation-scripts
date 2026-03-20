\# System Automation Scripts 🚀



!\[Python](https://img.shields.io/badge/Python-3.8%2B-blue)

!\[PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue)

!\[Bash](https://img.shields.io/badge/Bash-5.0%2B-orange)

!\[License](https://img.shields.io/badge/License-MIT-green)



A comprehensive collection of cross-platform automation scripts designed to streamline system maintenance, file organization, backup operations, and network monitoring. This project demonstrates practical automation skills essential for DevOps engineers, system administrators, and developers.



\## 📊 Overview



This toolkit provides ready-to-use automation solutions for everyday system administration tasks. Whether you need to organize your downloads folder, automate backups, monitor network connectivity, or clean up temporary files, these scripts have you covered. Built with best practices in error handling, logging, and configuration management.



\*\*Why this project?\*\* Automation is a critical skill in modern IT operations. This collection demonstrates:

\- Cross-platform scripting expertise (Windows/Linux/macOS)

\- Real-world automation scenarios

\- Enterprise-grade error handling and logging

\- Configuration-driven design

\- Testable and maintainable code structure



\## ✨ Key Features



\### Python Scripts 🐍

\- \*\*File Organizer\*\*: Automatically sorts files into folders by type, date, or custom rules

\- \*\*Backup Automation\*\*: Incremental backups with compression and cloud upload support

\- \*\*Log Analyzer\*\*: Parse and analyze system logs with pattern detection



\### PowerShell Scripts 💻

\- \*\*System Cleanup\*\*: Remove temporary files, clear caches, and free disk space

\- \*\*Network Monitor\*\*: Continuous network connectivity testing with alerts

\- \*\*Service Manager\*\*: Start/stop/restart Windows services with dependency checking



\### Bash Scripts 🐧

\- \*\*Git Automation\*\*: Batch git operations across multiple repositories

\- \*\*Log Rotator\*\*: Smart log rotation with compression and retention policies

\- \*\*Resource Monitor\*\*: CPU, memory, and disk usage tracking with alerts



\## 🏗️ Architecture

┌─────────────────────────────────────────────────────────────┐

│ System Automation Scripts │

├───────────────┬─────────────────┬───────────────────────────┤

│ Python │ PowerShell │ Bash │

│ Scripts │ Scripts │ Scripts │

├───────────────┼─────────────────┼───────────────────────────┤

│ • File Ops │ • Windows API │ • Linux Syscalls │

│ • Cross- │ • Registry │ • Text Processing │

│ Platform │ Management │ • Pipeline Operations │

└───────────────┴─────────────────┴───────────────────────────┘

│ │ │

▼ ▼ ▼

┌─────────────────────────────────────────────────────────────┐

│ Shared Components │

│ • Configuration Files (JSON/YAML) │

│ • Logging System │

│ • Error Handling \& Notifications │

└─────────────────────────────────────────────────────────────┘



\## 🛠️ Technologies Used



| Technology | Purpose |

|------------|---------|

| Python 3.8+ | Core automation logic, cross-platform compatibility |

| PowerShell | Windows-specific automation, system administration |

| Bash | Linux/macOS automation, shell scripting |

| JSON/YAML | Configuration management |

| Schedule | Task scheduling (Python) |

| Logging | Centralized logging across all scripts |

| Git | Version control and automation |



\## 📁 Project Structure



system-automation-scripts/

├── python/

│ ├── init.py # Python package marker

│ ├── file\_organizer.py # File organization automation

│ ├── backup\_automation.py # Backup management

│ └── requirements.txt # Python dependencies

├── powershell/

│ ├── system\_cleanup.ps1 # Disk cleanup utility

│ ├── network\_monitor.ps1 # Network monitoring

│ └── README.md # PowerShell specific docs

├── bash/

│ ├── git\_automation.sh # Git operations automation

│ ├── log\_rotator.sh # Log rotation utility

│ └── README.md # Bash specific docs

├── config/

│ ├── settings.json # Global configuration

│ └── backup\_config.json # Backup-specific config

├── tests/

│ ├── test\_python.py # Python unit tests

│ └── test\_powershell.ps1 # PowerShell tests

├── docs/

│ ├── images/ # Screenshots and diagrams

│ └── examples/ # Usage examples

├── .gitignore # Git ignore rules

├── LICENSE # MIT License

└── README.md # This file



\## 📸 Screenshots



\### File Organizer in Action

!\[File Organizer](docs/screenshots/screenshot\_1\_file\_organizer.png)



\### Backup Script

!\[Backup Script](docs/screenshots/screenshot\_2\_backup\_script.png)



\### Git Automation

!\[Git Automation](docs/screenshots/screenshot\_3\_git\_automation.png)



\### Project Structure

!\[VSCode Structure](docs/screenshots/screenshot\_4\_vscode\_structure.png)



\## 🚀 Getting Started (Windows Instructions)



\### Prerequisites



\- \*\*Python 3.8+\*\* (\[Download](https://www.python.org/downloads/))

\- \*\*Git\*\* (\[Download](https://git-scm.com/download/win))

\- \*\*PowerShell 5.1+\*\* (Built into Windows 10/11)

\- \*\*Git Bash\*\* (\[Included with Git](https://git-scm.com/download/win)) - for bash scripts

\- \*\*VS Code\*\* (recommended) (\[Download](https://code.visualstudio.com/))



\### Installation \& Setup



1\. \*\*Clone the repository\*\*

&#x20;  ```powershell

&#x20;  git clone https://github.com/dianadesiree/system-automation-scripts.git

&#x20;  cd system-automation-scripts



2\. \*\*Clone the repository\*\*

&#x20;  ```powershell

.\\setup.ps1



2\. \*\*Test Python scripts\*\*

&#x20;  ```powershell

cd python

python file\_organizer.py --help



Script Examples

Python File Organizer



\# Organize Downloads folder

python python/file\_organizer.py C:\\Users\\YourName\\Downloads



\# Organize by date within categories

python python/file\_organizer.py C:\\TestFolder --by-date



PowerShell Backup



\# Create compressed backup

.\\powershell\\backup\_script.ps1 -SourcePath "C:\\Important" -DestinationPath "D:\\Backups" -Compress



Bash Git Automation



\# Make script executable

chmod +x bash/git\_automation.sh



\# Run interactive git automation

./bash/git\_automation.sh /path/to/repo



📊 Sample Output

File Organizer Results



📁 Organizing files in: C:\\Users\\Downloads

&#x20; ✅ Moved: image.jpg -> Images/

&#x20; ✅ Moved: doc.pdf -> Documents/

&#x20; ✅ Moved: script.py -> Code/



✅ Organization complete!

&#x20;  Files moved: 15

&#x20;  Categories: 5

&#x20;  Statistics saved to: organization\_stats.json



Backup Script Output



==================================================

&#x20; SYSTEM BACKUP SCRIPT

==================================================

\[2024-01-15 14:30:45] \[INFO] Starting backup process...

\[2024-01-15 14:30:46] \[SUCCESS] Backup created: backup\_20240115\_143045.zip (125.3 MB)

\[2024-01-15 14:30:46] \[INFO] Backup rotation complete. Current backups: 5



🔧 Future Improvements

Add GUI interface for script selection



Implement email notifications for backup status



Create Docker containers for isolated execution



Add scheduling integration (Task Scheduler/Cron)



Develop REST API for remote execution



Add comprehensive test suite



🤝 Contributing

This is a personal learning project, but suggestions are welcome!



Issues: Report bugs or suggest features



Forks: Experiment and create pull requests



Ideas: Share improvements via email



📝 License

This project is licensed under the MIT License - see the LICENSE file for details.



📬 Contact

Diana Araujo



📧 Email: dianadaraujo78@gmail.com



🔗 LinkedIn: linkedin.com/in/dianadaraujo



🌐 Portfolio: dianadesiree3.wixsite.com/my-site



🐙 GitHub: github.com/dianadesiree



Note: These scripts are designed for educational purposes and personal automation. Test in a safe environment before using in production.

