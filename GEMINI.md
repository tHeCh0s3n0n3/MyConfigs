# MyConfigs Project Overview

This repository is a centralized collection of personal configuration files (dotfiles) and deployment scripts designed for consistent environment setup across Linux and Windows.

## Directory Overview

The project aims to maintain a unified development environment by managing configurations for shell prompts, text editors, version control, and monitoring utilities. It includes automated and interactive scripts to deploy these configurations to user home directories.

### Key Components

*   **Shell & Prompt:** Utilizes **Oh My Posh** with a custom theme (`tarekf.omp.yaml`) to provide a rich, informative CLI prompt.
*   **Text Editor:** A comprehensive **Vim** setup including a custom `.vimrc` with specialized functions (`SmartHome`, `GetEverythingUnderCursor`), status line enhancements, and cross-user (root) symlink support.
*   **Version Control:** Global **Git** settings (`.gitconfig`) and attribute handling (`.gitattributes`) to manage OS-specific line endings (LF for Unix, CRLF for Windows scripts).
*   **Monitoring:** Custom **Zabbix** agent parameters and Python scripts for SSL/Let's Encrypt certificate discovery and health monitoring.

## Key Files

| File/Directory | Description |
| :--- | :--- |
| `copy-configs.sh` | Bash deployment script (Linux). Supports interactive selection, automated `--init`, and selective component flags (`--git`, `--vim`, etc.). |
| `Copy-Configs.ps1` | PowerShell deployment script (Windows). Supports `-Unattended` and `-ForceCreateDirs` modes. |
| `.gitconfig` | User identification, color UI settings, and common aliases (`co`, `ci`, `st`, `hist`). |
| `.gitattributes` | Enforces LF for `.sh` and `.yaml`, and CRLF for `.ps1` files. |
| `vim/.vimrc` | Main Vim configuration with status line, tab settings, and custom key mappings. |
| `oh-my-posh/` | Theme definition for the Oh My Posh shell prompt. |
| `zabbix-custom/` | Zabbix agent user parameters and Python monitoring scripts. |

## Usage

### Linux Deployment
The `copy-configs.sh` script is the primary tool for Unix-like environments:

```bash
# Default: Interactive prompt-by-prompt
./copy-configs.sh

# Fully automated setup (bypasses prompts)
./copy-configs.sh --init

# Targeted component update
./copy-configs.sh --vim --git

# Deploy to a specific user's home (as root)
./copy-configs.sh --user <username> --init
```

### Windows Deployment
The `Copy-Configs.ps1` script handles Windows environment setup:

```powershell
# Interactive mode
.\Copy-Configs.ps1

# Unattended automation
.\Copy-Configs.ps1 -Unattended -ForceCreateDirs
```

## Development Conventions

*   **Line Endings:** Strictly managed via `.gitattributes`. Always ensure shell scripts use `LF` to avoid execution errors on Linux.
*   **Indentation:**
    *   Bash/Vim: 2 or 3 spaces (follow existing file headers/modelines).
    *   YAML: 2 spaces.
*   **Parity:** When adding new configuration types, ideally update both the Bash and PowerShell scripts to ensure platform consistency.

## Agent Instructions (Guardrails)

*   **Ignore `zabbix-custom/`:** This directory contains legacy/external scripts. Do **NOT** suggest refactors, documentation, or changes for these files unless explicitly asked.
*   **Root Usage:** If the user is running as root, always suggest using the `--user <username>` flag to ensure configs are placed in the correct home directory with proper ownership.
*   **Script Parity:** Changes to deployment logic in `copy-configs.sh` (Bash) should be mirrored in `Copy-Configs.ps1` (PowerShell) whenever possible.
