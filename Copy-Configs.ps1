Write-Output "Copying .gitconfig file to home directory"
Copy-Item .\.gitconfig $HOME\.gitconfig

Write-Output "Copying oh-my-posh custom config"
Copy-Item .\oh-my-posh\tarekf.omp.yaml $HOME\AppData\Local\Programs\oh-my-posh\themes\tarekf.omp.yaml
