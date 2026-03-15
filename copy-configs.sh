#!/bin/bash

echo "Copying .gitconfig to home directory"
cp ./.gitconfig ~/

if [ ! -d ~/.poshthemes ];then
  echo "Directory ~/.poshthemes doesn't exist."
  read -p "Create '~/.poshthemes' directory? [y/N]" createInHomeResponse

  case $createInHomeResponse in
    [Yy]* ) echo "Creating..."; mkdir ~/.poshthemes; break;;
    * ) echo "Terminating!"; exit 1; break;;
  esac
fi

echo "Copying tarekf.omp.yaml to ~/poshthemes"
cp ./oh-my-posh/tarekf.omp.yaml ~/.poshthemes/

while true; do
  read -p "Copy Oh My Posh config to /root/.poshtheme.omp.yaml? [y/N]" yn
  case $yn in
    [Yy]* ) echo "Copying..."; sudo cp ./oh-my-posh/tarekf.omp.yaml /root/.poshtheme.omp.yaml; break;;
    * ) echo "Skipping"; break;;
  esac
done
