# Design Spec: Deployable Bash Aliases on Linux

We want to allow the deployment of a new configuration file, `.bash_aliases`, located in `./bash/.bash_aliases`, to Linux target environments using the existing `copy-configs.sh` deployment script.

## Requirements

1. Provide a `--bash-aliases` CLI switch in `copy-configs.sh` to selectively copy `.bash_aliases`.
2. Include the deployment of `.bash_aliases` when running `copy-configs.sh` with the `--init` switch.
3. Support interactive prompts in `copy-configs.sh` to optionally copy the `.bash_aliases` file.
4. Enforce Unix-style (`lf`) line endings for the `.bash_aliases` file in `.gitattributes`.
5. Exclude Windows deployment (`Copy-Configs.ps1`) from these changes, as `.bash_aliases` is exclusive to Linux.

---

## Detailed Design

### 1. Script Modifications (`copy-configs.sh`)

#### Variables
Introduce `DO_BASH_ALIASES` variable:
```bash
DO_GIT=0
DO_VIM=0
DO_OMP=0
DO_BASH_ALIASES=0
```

#### CLI Argument Parsing
Update the argument parsing loop to recognize `--bash-aliases`:
```bash
    --init)
      DO_GIT=1
      DO_VIM=1
      DO_OMP=1
      DO_BASH_ALIASES=1
      INTERACTIVE=0
      ;;
    --bash-aliases)
      DO_BASH_ALIASES=1
      INTERACTIVE=0
      ;;
```
Also, update the help text:
```bash
    -h|--help)
      echo "Usage: $0 [--init] [--git] [--vim] [--oh-my-posh] [--bash-aliases] [-i|--interactive] [--user <username>]"
      exit 0
      ;;
```

#### Interactive Mode Prompts
Add a prompt for copying Bash aliases if interactive:
```bash
if [[ "$INTERACTIVE" -eq 1 ]]; then
  if ask_to_copy "Copy Git configs (${COLOR_FILE}.gitconfig${COLOR_RESET} and ${COLOR_FILE}.gitattributes${COLOR_RESET}) to target directory?"; then DO_GIT=1; fi
  if ask_to_copy "Copy vim files to target directory?"; then DO_VIM=1; fi
  if ask_to_copy "Copy Oh My Posh configs to ${COLOR_FILE}${TARGET_HOME}/.poshthemes${COLOR_RESET}?"; then DO_OMP=1; fi
  if ask_to_copy "Copy Bash aliases (${COLOR_FILE}.bash_aliases${COLOR_RESET}) to target directory?"; then DO_BASH_ALIASES=1; fi
fi
```

#### File Copy Logic
Copy the `.bash_aliases` file using `smart_copy`:
```bash
if [[ "$DO_BASH_ALIASES" -eq 1 ]]; then
  echo -e "Copying Bash aliases to target directory..."
  smart_copy ./bash/.bash_aliases "$TARGET_HOME/.bash_aliases"
fi
```

---

## 2. Git Attributes Configuration (`.gitattributes`)
Add the following line to ensure git handles the line endings correctly on check out:
```gitattributes
bash/.bash_aliases text eol=lf
```
