#!/bin/bash

echo "Copying .gitconfig to home directory"
cp ./.gitconfig ~/

echo "Copying tarekf.omp.yaml to ~/poshthemes"
cp ./oh-my-posh/tarekf.omp.yaml ~/.poshthemes/

while true; do
  read -p "Copy Oh My Posh config to /root/.poshtheme.omp.yaml? [y/N]" yn
  case $yn in
    [Yy]* ) echo "Copying..."; sudo cp ./oh-my-posh/tarekf.omp.yaml /root/.poshtheme.omp.yaml; break;;
    * ) echo "Skipping"; break;;
  esac
done