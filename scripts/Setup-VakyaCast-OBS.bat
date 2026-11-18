@echo off
title VakyaCast LT - Automatic OBS & Standalone Setup
echo ====================================================================
echo   VakyaCast Bible Lower-Third - Automatic OBS Installer & Repair
echo ====================================================================
echo.

set "TARGET_DIR=C:\OBS-VakyaCast"
if not exist "%TARGET_DIR%" mkdir "%TARGET_DIR%"

set "SRC_DIR=%~dp0.."
if not exist "%SRC_DIR%\bible_lower_third_studio.html" (
  set "SRC_DIR=%~dp0"
)

echo [*] Copying core studio files to %TARGET_DIR% ...
copy /Y "%SRC_DIR%\bible_lower_third_studio.html" "%TARGET_DIR%\bible_lower_third_studio.html" >nul
if exist "%SRC_DIR%\obs\obs_dock.html" copy /Y "%SRC_DIR%\obs\obs_dock.html" "%TARGET_DIR%\obs_dock.html" >nul
if exist "%SRC_DIR%\obs\obs_overlay.html" copy /Y "%SRC_DIR%\obs\obs_overlay.html" "%TARGET_DIR%\obs_overlay.html" >nul
if exist "%SRC_DIR%\obs\VakyaCast-OBS-Scene-Import.json" copy /Y "%SRC_DIR%\obs\VakyaCast-OBS-Scene-Import.json" "%TARGET_DIR%\VakyaCast-OBS-Scene-Import.json" >nul
if exist "%SRC_DIR%\scripts\Start-Browser-To-OBS-Bridge.bat" copy /Y "%SRC_DIR%\scripts\Start-Browser-To-OBS-Bridge.bat" "%TARGET_DIR%\Start-Browser-To-OBS-Bridge.bat" >nul
if exist "%SRC_DIR%\scripts\Download-Full-Bibles-Offline.bat" copy /Y "%SRC_DIR%\scripts\Download-Full-Bibles-Offline.bat" "%TARGET_DIR%\Download-Full-Bibles-Offline.bat" >nul
if exist "%SRC_DIR%\scripts\Build-Offline-Bible-Bundles.ps1" copy /Y "%SRC_DIR%\scripts\Build-Offline-Bible-Bundles.ps1" "%TARGET_DIR%\Build-Offline-Bible-Bundles.ps1" >nul
if exist "%SRC_DIR%\scripts\Uninstall-Previous-Setup.bat" copy /Y "%SRC_DIR%\scripts\Uninstall-Previous-Setup.bat" "%TARGET_DIR%\Uninstall-Previous-Setup.bat" >nul

if exist "%SRC_DIR%\bibles" (
  echo [*] Synchronizing offline Telugu OV & English KJV Bibles ...
  if not exist "%TARGET_DIR%\bibles" mkdir "%TARGET_DIR%\bibles"
  xcopy /E /I /Y /Q "%SRC_DIR%\bibles" "%TARGET_DIR%\bibles" >nul
)

echo [*] Checking and configuring OBS Studio integration ...
powershell -NoProfile -ExecutionPolicy Bypass -Command "
$obsData = [System.IO.Path]::Combine($env:APPDATA, 'obs-studio')
if (Test-Path $obsData) {
    # 1. Update/Add Bible Dock in user.ini & global.ini
    $iniFiles = @(Join-Path $obsData 'user.ini'), (Join-Path $obsData 'global.ini')
    foreach ($ini in $iniFiles) {
        if (Test-Path $ini) {
            $lines = Get-Content $ini
            $dockFound = $false
            $newLines = @()
            foreach ($line in $lines) {
                if ($line -like 'ExtraBrowserDocks=*') {
                    $dockFound = $true
                    $raw = $line.Substring('ExtraBrowserDocks='.Length)
                    $docks = @()
                    try { $docks = $raw | ConvertFrom-Json } catch {}
                    $hasBible = $false
                    foreach ($d in $docks) {
                        if ($d.title -eq 'Bible' -or $d.url -like '*VakyaCast*') {
                            $d.url = 'file:///C:/OBS-VakyaCast/bible_lower_third_studio.html?mode=dock'
                            $hasBible = $true
                        }
                    }
                    if (!$hasBible) {
                        $docks += [PSCustomObject]@{
                            title = 'Bible'
                            url = 'file:///C:/OBS-VakyaCast/bible_lower_third_studio.html?mode=dock'
                            uuid = [System.Guid]::NewGuid().ToString('N')
                        }
                    }
                    $jsonStr = $docks | ConvertTo-Json -Compress
                    $newLines += ('ExtraBrowserDocks=' + $jsonStr)
                } else {
                    $newLines += $line
                }
            }
            if (!$dockFound) {
                $newLines += ('ExtraBrowserDocks=[{\"title\":\"Bible\",\"url\":\"file:///C:/OBS-VakyaCast/bible_lower_third_studio.html?mode=dock\",\"uuid\":\"' + [System.Guid]::NewGuid().ToString('N') + '\"}]')
            }
            Set-Content -Path $ini -Value $newLines -Encoding UTF8
        }
    }

    # 2. Update Browser Source in scene collections
    $sceneFiles = Get-ChildItem (Join-Path $obsData 'basic\scenes\*.json') -ErrorAction SilentlyContinue
    foreach ($sf in $sceneFiles) {
        if ($sf.Name.EndsWith('.bak')) { continue }
        try {
            $content = Get-Content $sf.FullName -Raw -Encoding UTF8 | ConvertFrom-Json
            $changed = $false
            foreach ($src in $content.sources) {
                if ($src.name -eq 'Lower Thirds' -and $src.id -eq 'browser_source') {
                    $src.settings.url = 'file:///C:/OBS-VakyaCast/bible_lower_third_studio.html?mode=overlay'
                    $src.settings.width = 1920
                    $src.settings.height = 1080
                    $src.settings.fps = 60
                    $src.settings.restart_when_active = $false
                    $src.settings.shutdown = $false
                    $src.settings.is_local_file = $false
                    $changed = $true
                }
            }
            if ($changed) {
                $content | ConvertTo-Json -Depth 20 | Set-Content $sf.FullName -Encoding UTF8
                Write-Host ('  [+] Updated OBS Scene Collection: ' + $sf.Name)
            }
        } catch {}
    }
    Write-Host '  [+] OBS Docks & Browser Sources registered successfully.'
} else {
    Write-Host '  [-] OBS Studio AppData not found (OBS may not be installed in default location).'
}

# 3. Create Desktop Shortcuts
$desktop = [System.Environment]::GetFolderPath('Desktop')
if (Test-Path $desktop) {
    $studioUrlPath = Join-Path $desktop 'VakyaCast LT Control Studio.url'
    '[InternetShortcut]' + \"`r`n\" + 'URL=file:///C:/OBS-VakyaCast/bible_lower_third_studio.html' | Set-Content $studioUrlPath
    $wsh = New-Object -ComObject WScript.Shell
    $bridgeLnk = $wsh.CreateShortcut((Join-Path $desktop 'VakyaCast HTTP Bridge (Port 8765).lnk'))
    $bridgeLnk.TargetPath = 'C:\OBS-VakyaCast\Start-Browser-To-OBS-Bridge.bat'
    $bridgeLnk.WorkingDirectory = 'C:\OBS-VakyaCast'
    $bridgeLnk.Description = 'Start VakyaCast Cross-Browser HTTP Bridge'
    $bridgeLnk.Save()
    Write-Host '  [+] Desktop Shortcuts created.'
}
"

echo file:///C:/OBS-VakyaCast/bible_lower_third_studio.html?mode=dock| clip

echo.
echo ====================================================================
echo   [SUCCESS] VakyaCast LT installed to C:\OBS-VakyaCast\ !
echo   - OBS Custom Dock URL:    file:///C:/OBS-VakyaCast/bible_lower_third_studio.html?mode=dock
echo   - OBS Browser Source URL: file:///C:/OBS-VakyaCast/bible_lower_third_studio.html?mode=overlay
echo   - Desktop Shortcuts:      Created on your Desktop
echo   - Clipboard:              Dock URL copied to clipboard!
echo ====================================================================
pause
