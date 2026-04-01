#!/bin/bash

COLOR_FILE=$'\001\e[38;2;253;216;53m\002'
COLOR_RESET=$'\001\e[0m'

DO_GIT=0
DO_VIM=0
DO_OMP=0
INTERACTIVE=1
TARGET_USER=""

# Helper for interactive prompts (defaults to No on enter)
# Uses -ep so that color codes passed in the prompt are evaluated
ask_to_copy() {
  local prompt="$1"
  while true; do
    read -ep "$prompt [y/N]: " response
    case "$response" in
      [yY]|[yY][eE][sS]) return 0 ;;
      [nN]|[nN][oO]|"") return 1 ;;
      *) echo "Please answer yes or no." ;;
    esac
  done
}

while [[ "$#" -gt 0 ]]; do
  case $1 in
    --init)
      DO_GIT=1
      DO_VIM=1
      DO_OMP=1
      INTERACTIVE=0
      ;;
    --git)
      DO_GIT=1
      INTERACTIVE=0
      ;;
    --vim)
      DO_VIM=1
      INTERACTIVE=0
      ;;
    --oh-my-posh|--omp)
      DO_OMP=1
      INTERACTIVE=0
      ;;
    -i|--interactive)
      INTERACTIVE=1
      ;;
    --user)
      TARGET_USER="$2"
      shift
      ;;
    -h|--help)
      echo "Usage: $0 [--init] [--git] [--vim] [--oh-my-posh] [-i|--interactive] [--user <username>]"
      exit 0
      ;;
    *)
      echo "Unknown parameter passed: $1"
      exit 1
      ;;
  esac
  shift
done

if [[ -z "$TARGET_USER" ]]; then
  if [[ "$(id -u)" -eq 0 ]]; then
    if [[ "$INTERACTIVE" -eq 1 ]]; then
      if ! ask_to_copy "You are running as root. Are you sure you don't want to specify a --user to place configs in their home directory?"; then
        echo "Please re-run the script with --user <username>"
        exit 1
      fi
    else
      echo "Warning: Running as root without --user specified. Using /root."
    fi
  fi
  TARGET_USER=$(id -un)
  TARGET_HOME=$HOME
else
  TARGET_HOME=$(getent passwd "$TARGET_USER" | cut -d: -f6)
  if [[ -z "$TARGET_HOME" ]]; then
    echo "User $TARGET_USER not found."
    exit 1
  fi
fi

TARGET_GROUP=$(id -g -n "$TARGET_USER" 2>/dev/null || echo "$TARGET_USER")

# Helper for copying files with overwrite prompts and ownership changes
smart_copy() {
  local src="$1"
  local dest="$2"
  
  if [[ -e "$dest" ]] && [[ "$INTERACTIVE" -eq 1 ]]; then
    if ! ask_to_copy "${COLOR_FILE}${dest}${COLOR_RESET} already exists. Overwrite?"; then
      echo "Skipping..."
      return 1
    fi
  fi
  
  cp -r "$src" "$dest"
  chown -R "$TARGET_USER:$TARGET_GROUP" "$dest" 2>/dev/null || true
}

if [[ "$INTERACTIVE" -eq 1 ]]; then
  if ask_to_copy "Copy Git configs (${COLOR_FILE}.gitconfig${COLOR_RESET} and ${COLOR_FILE}.gitattributes${COLOR_RESET}) to target directory?"; then DO_GIT=1; fi
  if ask_to_copy "Copy vim files to target directory?"; then DO_VIM=1; fi
  if ask_to_copy "Copy Oh My Posh configs to ${COLOR_FILE}${TARGET_HOME}/.poshthemes${COLOR_RESET}?"; then DO_OMP=1; fi
fi

if [[ "$DO_GIT" -eq 1 ]]; then
  echo -e "Copying Git configs to target directory..."
  smart_copy ./.gitconfig "$TARGET_HOME/.gitconfig"
  smart_copy ./.gitattributes "$TARGET_HOME/.gitattributes"
fi

if [[ "$DO_VIM" -eq 1 ]]; then
  echo "Copying vim files to target directory..."
  smart_copy ./vim/.vimrc "$TARGET_HOME/.vimrc"
  smart_copy ./vim/.vim "$TARGET_HOME/.vim"

  if [[ "$TARGET_HOME" != "/root" ]]; then
    if [[ "$INTERACTIVE" -eq 1 ]]; then
      if ask_to_copy "Create symlinks for ${COLOR_FILE}.vimrc${COLOR_RESET} and ${COLOR_FILE}.vim/${COLOR_RESET} in ${COLOR_FILE}/root/${COLOR_RESET} (requires sudo)?"; then
        echo -e "Creating symlinks in ${COLOR_FILE}/root/${COLOR_RESET}..."
        sudo ln -sf "$TARGET_HOME/.vimrc" /root/.vimrc
        sudo rm -rf /root/.vim
        sudo ln -sf "$TARGET_HOME/.vim" /root/.vim
      fi
    else
      echo -e "Creating symlinks for vim files in ${COLOR_FILE}/root/${COLOR_RESET} (requires sudo)..."
      sudo ln -sf "$TARGET_HOME/.vimrc" /root/.vimrc
      sudo rm -rf /root/.vim
      sudo ln -sf "$TARGET_HOME/.vim" /root/.vim
    fi
  fi
fi

if [[ "$DO_OMP" -eq 1 ]]; then
  if [ ! -d "$TARGET_HOME/.poshthemes" ]; then
    echo -e "Creating ${COLOR_FILE}${TARGET_HOME}/.poshthemes${COLOR_RESET} directory..."
    mkdir -p "$TARGET_HOME/.poshthemes"
    chown "$TARGET_USER:$TARGET_GROUP" "$TARGET_HOME/.poshthemes" 2>/dev/null || true
  fi
  
  echo -e "Copying ${COLOR_FILE}tarekf.omp.yaml${COLOR_RESET} to ${COLOR_FILE}${TARGET_HOME}/.poshthemes${COLOR_RESET}..."
  smart_copy ./oh-my-posh/tarekf.omp.yaml "$TARGET_HOME/.poshthemes/tarekf.omp.yaml"

  if [[ "$TARGET_HOME" != "/root" ]]; then
    if [[ "$INTERACTIVE" -eq 1 ]]; then
      if ask_to_copy "Copy Oh My Posh config to ${COLOR_FILE}/root/.poshtheme.omp.yaml${COLOR_RESET} (requires sudo)?"; then
        echo -e "Copying to ${COLOR_FILE}/root/.poshtheme.omp.yaml${COLOR_RESET}..."
        sudo cp ./oh-my-posh/tarekf.omp.yaml /root/.poshtheme.omp.yaml
      fi
    else
      echo -e "Copying Oh My Posh config to ${COLOR_FILE}/root/.poshtheme.omp.yaml${COLOR_RESET} (requires sudo)..."
      sudo cp ./oh-my-posh/tarekf.omp.yaml /root/.poshtheme.omp.yaml
    fi
  fi
fi

# vim: syntax=sh ts=2 sw=2 sts=2 sr et
