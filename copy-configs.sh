#!/bin/bash

COLOR_FILE=$'\001\e[38;2;253;216;53m\002'
COLOR_RESET=$'\001\e[0m'

echo -e "Copying $COLOR_FILE.gitconfig$COLOR_RESET to home directory..."
cp ./.gitconfig ~/.gitconfig

echo "Copying vim files to home directory..."
echo -e "Copying $COLOR_FILE.vimrc$COLOR_RESET..."
cp ./vim/.vimrc ~/.vimrc
echo -e "Copying $COLOR_FILE.vim/$COLOR_RESET..."
cp -r ./vim/.vim ~/.vim

if [ ! -d ~/.poshthemes ];then
  echo -e "Directory $COLOR_FILE~/.poshthemes$COLOR_RESET doesn't exist."
  read -p "Create '$COLOR_FILE~/.poshthemes$COLOR_RESET' directory? [y/N]" createInHomeResponse

  case $createInHomeResponse in
    [Yy]* ) echo "Creating ..."; mkdir ~/.poshthemes; break;;
    * ) echo "Terminating!"; exit 1; break;;
  esac
fi

echo -e "Copying ${COLOR_FILE}tarekf.omp.yaml$COLOR_RESET to $COLOR_FILE~/.poshthemes$COLOR_RESET..."
cp ./oh-my-posh/tarekf.omp.yaml ~/.poshthemes/

while true; do
  read -ep "Copy Oh My Posh config to ${COLOR_FILE}/root/.poshtheme.omp.yaml${COLOR_RESET}? [y/N]" yn
  case $yn in
    [Yy]* ) echo "Copying..."; sudo cp ./oh-my-posh/tarekf.omp.yaml /root/.poshtheme.omp.yaml; break;;
    * ) echo "Skipping"; break;;
  esac
done

# vim: syntax=sh ts=2 sw=2 sts=2 sr et
