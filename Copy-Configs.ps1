param (
    [switch]$Unattended,
    [switch]$ForceCreateDirs
)

function Copy-WithCheck {
    param (
        [string]$Source,
        [string]$Destination,
        [string]$Description
    )

    # 1. File Copy Confirmation (The Gatekeeper)
    if (-not $Unattended) {
        $confirmCopy = Read-Host "Copy ${Description}? (y/N)"
        if ($confirmCopy -notmatch "^y$|^yes$") {
            Write-Host "Skipped: ${Description}" -ForegroundColor Yellow
            return
        }
    }

    # 2. Directory Existence Check
    $destDir = Split-Path -Parent $Destination
    if (-not (Test-Path -Path $destDir)) {

        $shouldCreate = $false

        if ($ForceCreateDirs) {
            $shouldCreate = $true
        }
        elseif (-not $Unattended) {
            $choice = Read-Host "Directory '$destDir' does not exist. Create it? (y/N)"
            if ($choice -match "^y$|^yes$") { $shouldCreate = $true }
        }

        # 3. Create directory or skip
        if ($shouldCreate) {
            New-Item -ItemType Directory -Path $destDir -Force | Out-Null
            Write-Host "Created directory: $destDir" -ForegroundColor Cyan
        }
        else {
            # FIX: Using ${Description} to prevent ':' from being read as part of the variable name
            Write-Warning "Skipping ${Description}: Destination directory does not exist and was not created."
            return
        }
    }

    # 4. Perform the copy
    Write-Host "Copying ${Description}..." -ForegroundColor Green
    Copy-Item -Path $Source -Destination $Destination -Force
}

# --- Execution ---

# .gitconfig
Copy-WithCheck `
    -Source ".\.gitconfig" `
    -Destination "$HOME\.gitconfig" `
    -Description ".gitconfig"

# oh-my-posh custom config
Copy-WithCheck `
    -Source ".\oh-my-posh\tarekf.omp.yaml" `
    -Destination "$HOME\AppData\Local\Programs\oh-my-posh\themes\tarekf.omp.yaml" `
    -Description "oh-my-posh config"