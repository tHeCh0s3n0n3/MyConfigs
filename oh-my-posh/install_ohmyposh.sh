#!/bin/bash

echo "Installing Oh My Posh (will prompt for elevation)"
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh > /dev/null
sudo chmod +x /usr/local/bin/oh-my-posh > /dev/null

echo "Grabbing themes"
mkdir ~/.poshthemes > /dev/null
wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O ~/.poshthemes/themes.zip > /dev/null

unzip ~/.poshthemes/themes.zip -d ~/.poshthemes > /dev/null
if [[ $? -ne 0 ]]; then
  echo "Unzip not found, installing it..."
  sudo apt install -y unzip > /dev/null
  unzip ~/.poshthemes/themes.zip -d ~/.poshthemes > /dev/null
fi
chmod u+rw ~/.poshthemes/*.omp.* > /dev/null
rm ~/.poshthemes/themes.zip > /dev/null


if [[ ! -f ~/.bashrc.omp.bak ]]; then
  USER_PROMPT='eval "$(oh-my-posh init bash --config ~/.poshthemes/tarekf.omp.yaml)"'
  echo "Adding oh-my-posh to ~/.bashrc with config file located at ~/.poshthemes/tarekf.omp.yaml"
  cp ~/.bashrc ~/.bashrc.omp.bak
  echo "" >> ~/.bashrc
  echo $USER_PROMPT >> ~/.bashrc
else 
  echo "Found backup ~/.bashrc file, skipping adding prompt to file"
fi

while true; do
  read -p "Add Oh My Posh to root's .bashrc file? [y/N]" yn
  case $yn in
    [Yy]* ) echo "Adding..."; sudo bash -c "echo '' >> /root/.bashrc"; sudo bash -c "echo 'eval \"\$(oh-my-posh init bash --config /root/.poshtheme.omp.yaml)\"' >> /root/.bashrc"; break;;
    * ) echo "Skipping"; break;;
  esac
done

echo "Oh My Posh inslled!"
echo "#########"
echo "# NOTES #"
echo "#########"
echo "Remember to copy your config file to ~/.poshthemes/tarekf.omp.yaml and /root/.poshtheme.omp.yaml"