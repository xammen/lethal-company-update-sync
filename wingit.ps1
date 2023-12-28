# Fonction pour afficher un texte en couleur
function Write-ColorText {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('Black', 'DarkBlue', 'DarkGreen', 'DarkCyan', 'DarkRed', 'DarkMagenta', 'DarkYellow', 'Gray', 'DarkGray', 'Blue', 'Green', 'Cyan', 'Red', 'Magenta', 'Yellow', 'White')]
        [string]$Color,
        [Parameter(Mandatory=$true)]
        [string]$Text
    )
    
    Write-Host $Text -ForegroundColor $Color
}

# Couleurs personnalisées
$successColor = 'Green'
$errorColor = 'Red'

Write-ColorText -Color 'Cyan' -Text "*******************************"
Write-ColorText -Color 'Cyan' -Text "*                             *"
Write-ColorText -Color 'Cyan' -Text "*  Bienvenue dans l'installeur *"
Write-ColorText -Color 'Cyan' -Text "*          de moha !           *"
Write-ColorText -Color 'Cyan' -Text "*                             *"
Write-ColorText -Color 'Cyan' -Text "*******************************"
Write-Host

# Vérifie si l'execution de scripts PowerShell est autorisée
if (!(Get-ExecutionPolicy -Scope CurrentUser -ErrorAction SilentlyContinue)) {
    Write-Host "Autorisation requise pour exécuter des scripts PowerShell. Demande en cours..."
    Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force
}

# Vérifie si Winget est déjà installé
$wingetInstalled = Get-Command -Name winget -ErrorAction SilentlyContinue
if ($wingetInstalled -eq $null) {
    Write-ColorText -Color 'Yellow' -Text "Installation de Winget..."
    
    # Télécharge et installe Winget
    $wingetUrl = 'https://aka.ms/winget-cli'
    $wingetInstaller = Join-Path $env:TEMP 'winget-cli.appxbundle.zip'
    Invoke-WebRequest -Uri $wingetUrl -OutFile $wingetInstaller -UseBasicParsing
    $extractPath = Join-Path $env:ProgramFiles '\WindowsApps\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe'
    $extractedFolder = Get-ChildItem -Path $extractPath | Select-Object -First 1
    Expand-Archive -Path $wingetInstaller -DestinationPath $extractPath
    $appxManifest = Join-Path $extractedFolder.FullName 'AppxManifest.xml'
    Add-AppxPackage -Path $appxManifest -Register
    
    Write-ColorText -Color $successColor -Text "Winget est installé avec succès."
    Write-Host
}

# Installation de Git en mode silencieux en utilisant Winget
Write-ColorText -Color 'Yellow' -Text "Installation de Git..."
$gitInstallationResult = winget install Git.git --silent

if ($gitInstallationResult -match 'Successfully installed Git') {
    Write-ColorText -Color $successColor -Text "Git est installé avec succès."
} else {
    Write-ColorText -Color $errorColor -Text "Une erreur s'est produite lors de l'installation de Git."
}

Write-Host
