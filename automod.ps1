$installedMods = @()
$OutputEncoding = [System.Text.Encoding]::UTF8

# Définir une fonction pour télécharger le contenu d'une URL vers un flux de mémoire
function Request-Stream($url) {
    $webClient = New-Object System.Net.WebClient
    $webClient.Headers.Add("User-Agent", "PowerShell Mod Downloader")
    return [System.IO.MemoryStream]::new($webClient.DownloadData($url))
}

# Définir une fonction pour extraire le contenu d'un flux vers un répertoire spécifique
function Expand-Stream($stream, $destination) {
    # Créer un fichier temporaire pour sauvegarder le contenu du flux
    $tempFilePath = [System.IO.Path]::GetTempFileName()
    # Changer l'extension du fichier temporaire en .zip
    $tempFilePath = [System.IO.Path]::ChangeExtension($tempFilePath, "zip")
    # Sauvegarder le contenu du flux dans le fichier temporaire
    $fileStream = [System.IO.File]::Create($tempFilePath)
    $stream.CopyTo($fileStream)
    $fileStream.Close()
    # Extraire le contenu du fichier ZIP temporaire vers le répertoire de destination
    Expand-Archive -LiteralPath $tempFilePath -DestinationPath $destination -Force
    # Supprimer le fichier temporaire
    Remove-Item -Path $tempFilePath -Force
}

function Show-LoadingScreen {
    $loadingMessage = "Téléchargement en cours..."
    $progress = 0

    # Définition des couleurs pour l'interface de chargement
    $foregroundColor = "White"
    $backgroundColor = "DarkBlue"

    # Définir les couleurs de la console pour l'interface de chargement
    $originalForegroundColor = $host.UI.RawUI.ForegroundColor
    $originalBackgroundColor = $host.UI.RawUI.BackgroundColor
    $host.UI.RawUI.ForegroundColor = $foregroundColor
    $host.UI.RawUI.BackgroundColor = $backgroundColor

    Write-Progress -Activity $loadingMessage -Status "$progress% Complete" -PercentComplete $progress

    while ($progress -lt 100) {
        $progress += 10
        Write-Progress -Activity $loadingMessage -Status "$progress% Complete" -PercentComplete $progress
        Start-Sleep -Milliseconds 500
    }

    # Réinitialiser les couleurs de la console
    $host.UI.RawUI.ForegroundColor = $originalForegroundColor
    $host.UI.RawUI.BackgroundColor = $originalBackgroundColor
}

# Définir une fonction pour récupérer les informations d'un mod et télécharger la dernière version
# Définir une fonction pour télécharger et installer un mod
function Download-Mod($namespace, $modName, $destination) {
    $modInfoUrl = "https://thunderstore.io/api/experimental/package/$namespace/$modName/"
    $modInfo = Invoke-RestMethod -Uri $modInfoUrl
    $downloadUrl = $modInfo.latest.download_url

    # Afficher l'interface de chargement
    Show-LoadingScreen

    # Télécharger le mod en utilisant curl
    $outputFile = Join-Path $destination "$modName.zip"
    & curl -o $outputFile $downloadUrl

    # Ajouter le nom du mod à la liste des mods installés
    $installedMods += $modInfo.name
}



# Définir le chemin du répertoire d'installation des mods
# Définir le chemin du répertoire d'installation des mods en utilisant le répertoire courant
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$modInstallPath = $scriptPath
$GMinstallPath = Join-Path $scriptPath "BepInEx\plugins"

Remove-Item -Path (Join-Path $scriptPath "BepInEx\plugins") -Recurse -Force
# Télécharger et installer GameMaster

# Télécharger et installer More Suits (Assurez-vous de remplacer le nom du namespace et du mod par les bons)
# Supposons que les valeurs correctes sont fournies ici pour l'exemple :
Download-Mod "WholeLottaIdiots" "CartiSuit" $modInstallPath

Download-Mod "x753" "More_Suits" $modInstallPath

Download-Mod "bizzlemip" "BiggerLobby" $modInstallPath 

Download-Mod "2018" "LC_API" $modInstallPath

Download-Mod "FlipMods" "ReservedWalkieSlot" $modInstallPath

#Download-Mod "5Bit" "FPSSpectate" $modInstallPath

#Download-Mod "tinyhoot" "ShipLobby" "BepInEx"

#Download-Mod "oknorton" "LethalCompanyBetterScaling" "BepInEx\plugins"

Download-Mod "Pooble" "LCBetterSaves" "BepInEx\plugins"

#Download-Mod "tinyhoot" "ShipLoot" "BepInEx"

#Download-Mod "FlipMods" "SkipToMultiplayerMenu" $modInstallPath

Download-Mod "FlipMods" "ReservedItemSlotCore" $modInstallPath

# Afficher le résumé des mods téléchargés en couleur verte
$foregroundColor = "Green"
$originalForegroundColor = $host.UI.RawUI.ForegroundColor
$host.UI.RawUI.ForegroundColor = $foregroundColor

Write-Host "Résumé des mods téléchargés :"
foreach ($mod in $installedMods) {
    Write-Host "- $mod"
}

# Réinitialiser la couleur de la console
$host.UI.RawUI.ForegroundColor = $originalForegroundColor

# Attendre que l'utilisateur appuie sur la touche "x" pour fermer le script
Write-Host "Appuyez sur la touche X pour fermer le script." -NoNewline
do {
    $key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character
} while ($key -ne 'x')
