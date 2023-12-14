chcp 65001 > $null

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

# Définir une fonction pour récupérer les informations d'un mod et télécharger la dernière version
function Download-Mod($namespace, $modName, $destination) {
    $modInfoUrl = "https://thunderstore.io/api/experimental/package/$namespace/$modName/"
    $modInfo = Invoke-RestMethod -Uri $modInfoUrl
    $downloadUrl = $modInfo.latest.download_url
    $stream = Request-Stream $downloadUrl
    Expand-Stream $stream $destination
    Write-Host -NoNewline "Mod '"
    Write-Host -NoNewline $modInfo.name -ForegroundColor Blue
    Write-Host -NoNewline "' version '"
    Write-Host -NoNewline $modInfo.latest.version_number -ForegroundColor Yellow
    Write-Host "' has been downloaded and installed."
}

function Download-MP3($url, $destination) {
    $webClient = New-Object System.Net.WebClient
    $webClient.Headers.Add("User-Agent", "PowerShell MP3 Downloader")
    $webClient.DownloadFile($url, $destination)
    Write-Host -NoNewline "MP3 '"
    Write-Host -NoNewline $url -ForegroundColor Blue
    Write-Host "' has been downloaded and placed in '"
    Write-Host -NoNewline $destination -ForegroundColor Yellow
    Write-Host "'."
}

# Définir le chemin du répertoire d'installation des mods
# Définir le chemin du répertoire d'installation des mods en utilisant le répertoire courant
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$modInstallPath = $scriptPath
$GMinstallPath = Join-Path $scriptPath "BepInEx\plugins"


# Télécharger et installer GameMaster

# Télécharger et installer More Suits (Assurez-vous de remplacer le nom du namespace et du mod par les bons)
# Supposons que les valeurs correctes sont fournies ici pour l'exemple :

Download-Mod "2018" "LC_API" $modInstallPath

Download-Mod "bizzlemip" "BiggerLobby" $modInstallPath

Download-Mod "x753" "More_Suits" $modInstallPath

Download-Mod "Verity" "TooManySuits" "BepInEx"

Download-Mod "FlipMods" "BetterStamina" $GMinstallPath

Download-Mod "Pooble" "LCBetterSaves" $GMinstallPath

Download-Mod "RugbugRedfern" "Skinwalkers" $scriptPath

##Download-Mod "Suskitech" "AlwaysHearActiveWalkies" $GMinstallPath

Download-Mod "stormytuna" "KindTeleporters" $GMinstallPath

Download-Mod "FlipMods" "SkipToMultiplayerMenu" $modInstallPath

Download-Mod "femboytv" "LethalPosters" $GMinstallPath

Download-Mod "WindSeries" "Non_Officielle_Traduction_FR" $modInstallPath

Download-Mod "RickArg" "Helmet_Cameras" $modInstallPath

Download-Mod "KoderTeh" "Boombox_Controller" $modInstallPath

Download-Mod "CYW" "DevysOQLMod" $modInstallPath

Download-Mod "Rattenbonkers" "Teleporter_Cooldown_Reset" $GMinstallPath

Download-Mod "Sligili" "More_Emotes" $modInstallPath

Download-Mod "tinyhoot" "ShipLobby" "BepInEx"

Download-Mod "x753" "Mimics" $scriptPath

Download-Mod "Sligili" "HDLethalCompany" $scriptPath

Download-Mod "QuokkaCrew" "MoreMonsters" $GMinstallPath

##Download-Mod "Aeclipse" "EEM_SKINS" "BepInEx"

##Download-Mod "WholeLottaIdiots" "CartiSuit" $modInstallPath

##Download-Mod "GameMasterDevs" "GameMaster" $GMinstallPath

#Download-Mod "Steven" "Custom_Boombox_Music" $GMinstallPath

#Download-Mod "5Bit" "FPSSpectate" $modInstallPath

#Download-Mod "oknorton" "LethalCompanyBetterScaling" "BepInEx\plugins"

#Download-Mod "tinyhoot" "ShipLoot" "BepInEx"

#Download-Mod "FlipMods" "SkipToMultiplayerMenu" $modInstallPath

#Download-Mod "FlipMods" "ReservedWalkieSlot" $modInstallPath

#Download-Mod "FlipMods" "ReservedItemSlotCore" $GMinstallPath

# Le chemin du fichier MP3 sur Github
#$mp3Url = "https://github.com/xammen/lethal-company-update-sync/raw/main/voyage.mp3" # Remplacer par l'URL réelle du fichier MP3

# Le chemin de destination du fichier MP3
#$mp3Destination = Join-Path $scriptPath "BepInEx\Custom Songs\Boombox Music\voyage.mp3" # Remplacer "somefile.mp3" par le nom réel du fichier.

# Appel à la fonction Download-MP3 pour télécharger et sauvegarder le fichier MP3
#Download-MP3 $mp3Url $mp3Destination
