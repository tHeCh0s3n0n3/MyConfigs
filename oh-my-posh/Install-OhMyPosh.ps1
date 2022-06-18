Write-Output "Installing Oh My Posh"
winget install JanDeDobbeleer.OhMyPosh

Write-Output "Installing fonts"
Start-Process powershell -Verb RunAs "oh-my-posh font install"

Write-Output "Oh My Posh and fonts are installed"
Write-Output "#########"
Write-Output "# Notes #"
Write-Output "#########"
Write-Output "- Remember to use the new fonts"
Write-Output "- Update your prompt to use oh-my-posh"
Write-Output "- Restart your terminal to load the new path"