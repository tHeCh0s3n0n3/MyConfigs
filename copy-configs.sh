#!/bin/bash

COLOR_FILE=$'\001\e[38;2;253;216;53m\002'
COLOR_RESET=$'\001\e[0m'

DO_GIT=0
DO_VIM=0
DO_OMP=0
INTERACTIVE=1

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
    -h|--help)
      echo "Usage: $0 [--init] [--git] [--vim] [--oh-my-posh] [-i|--interactive]"
      exit 0
      ;;
    *)
      echo "Unknown parameter passed: $1"
      exit 1
      ;;
  esac
  shift
done

if [[ "$INTERACTIVE" -eq 1 ]]; then
  if ask_to_copy "Copy Git configs (${COLOR_FILE}.gitconfig${COLOR_RESET} and ${COLOR_FILE}.gitattributes${COLOR_RESET}) to home directory?"; then DO_GIT=1; fi
  if ask_to_copy "Copy vim files to home directory?"; then DO_VIM=1; fi
  if ask_to_copy "Copy Oh My Posh configs to ${COLOR_FILE}~/.poshthemes${COLOR_RESET}?"; then DO_OMP=1; fi
fi

if [[ "$DO_GIT" -eq 1 ]]; then
  echo -e "Copying ${COLOR_FILE}.gitconfig${COLOR_RESET} to home directory..."
  cp ./.gitconfig ~/.gitconfig
  echo -e "Copying ${COLOR_FILE}.gitattributes${COLOR_RESET} to home directory..."
  cp ./.gitattributes ~/.gitattributes
fi

if [[ "$DO_VIM" -eq 1 ]]; then
  echo "Copying vim files to home directory..."
  echo -e "Copying ${COLOR_FILE}.vimrc${COLOR_RESET}..."
  cp ./vim/.vimrc ~/.vimrc
  echo -e "Copying ${COLOR_FILE}.vim/${COLOR_RESET}..."
  cp -r ./vim/.vim ~/.vim

  if [[ "$INTERACTIVE" -eq 1 ]]; then
    if ask_to_copy "Create symlinks for ${COLOR_FILE}.vimrc${COLOR_RESET} and ${COLOR_FILE}.vim/${COLOR_RESET} in ${COLOR_FILE}/root/${COLOR_RESET} (requires sudo)?"; then
      echo -e "Creating symlinks in ${COLOR_FILE}/root/${COLOR_RESET}..."
      sudo ln -sf ~/.vimrc /root/.vimrc
      sudo rm -rf /root/.vim
      sudo ln -sf ~/.vim /root/.vim
    fi
  else
    echo -e "Creating symlinks for vim files in ${COLOR_FILE}/root/${COLOR_RESET} (requires sudo)..."
    sudo ln -sf ~/.vimrc /root/.vimrc
    sudo rm -rf /root/.vim
    sudo ln -sf ~/.vim /root/.vim
  fi
fi

if [[ "$DO_OMP" -eq 1 ]]; then
  if [ ! -d ~/.poshthemes ]; then
    echo -e "Creating ${COLOR_FILE}~/.poshthemes${COLOR_RESET} directory..."
    mkdir -p ~/.poshthemes
  fi
  
  echo -e "Copying ${COLOR_FILE}tarekf.omp.yaml${COLOR_RESET} to ${COLOR_FILE}~/.poshthemes${COLOR_RESET}..."
  cp ./oh-my-posh/tarekf.omp.yaml ~/.poshthemes/

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

# vim: syntax=sh ts=2 sw=2 sts=2 sr et
