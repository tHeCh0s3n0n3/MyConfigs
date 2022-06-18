Write-Output "Installing Oh My Posh"
#winget install JanDeDobbeleer.OhMyPosh

Write-Output "Installing fonts"
#Start-Process powershell -Verb RunAs "oh-my-posh font install"

Write-Output "Oh My Posh and fonts are installed"
Write-Output "#########"
Write-Output "# Notes #"
Write-Output "#########"
Write-Output "- Remember to use the new fonts"
Write-Output "- Restart your terminal to load the new path"
Write-Output "- Add 'oh-my-posh init pwsh | Invoke-Expression' to $PROFILE"
if (-Not (Test-Path -Path $PROFILE)) {
    Write-Host -NoNewline "  Adding Oh My Posh to profile automatically..."
    [void](New-Item -Path $PROFILE -Type File -Force -Value @'
    $host.PrivateData.ErrorForegroundColor = "White"
    $host.PrivateData.ErrorBackgroundColor = "Red"
    oh-my-posh init pwsh | Invoke-Expression
'@)
    Write-Host " Done"
}