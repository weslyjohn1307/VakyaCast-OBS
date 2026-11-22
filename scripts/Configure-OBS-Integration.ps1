# VakyaCast LT - Safe OBS Studio Dock, Scene Source & Shortcut Configurator
$ErrorActionPreference = 'Stop'

$obsData = Join-Path $env:APPDATA 'obs-studio'
if (Test-Path $obsData) {
    # 1. Register / Update Bible Custom Browser Dock in user.ini & global.ini
    $iniFiles = @(Join-Path $obsData 'user.ini'), (Join-Path $obsData 'global.ini')
    foreach ($ini in $iniFiles) {
        if (Test-Path $ini) {
            $lines = Get-Content $ini -Encoding UTF8
            $dockFound = $false
            $newLines = @()
            foreach ($line in $lines) {
                if ($line -like 'ExtraBrowserDocks=*') {
                    $dockFound = $true
                    $raw = $line.Substring('ExtraBrowserDocks='.Length)
                    $docks = @()
                    try {
                        $parsed = $raw | ConvertFrom-Json
                        if ($parsed -is [System.Array]) { $docks = @($parsed) } elseif ($parsed) { $docks = @($parsed) }
                    } catch {}
                    $hasBible = $false
                    foreach ($d in $docks) {
                        if ($d.title -eq 'Bible' -or $d.url -like '*VakyaCast*') {
                            $d.url = 'file:///C:/OBS-VakyaCast/bible_lower_third_studio.html?mode=dock'
                            $hasBible = $true
                        }
                    }
                    if (-not $hasBible) {
                        $docks += [PSCustomObject]@{
                            title = 'Bible'
                            url   = 'file:///C:/OBS-VakyaCast/bible_lower_third_studio.html?mode=dock'
                            uuid  = [System.Guid]::NewGuid().ToString('N')
                        }
                    }
                    $jsonStr = ConvertTo-Json -InputObject @($docks) -Compress
                    $newLines += ('ExtraBrowserDocks=' + $jsonStr)
                } else {
                    $newLines += $line
                }
            }
            if (-not $dockFound) {
                $docks = @([PSCustomObject]@{
                    title = 'Bible'
                    url   = 'file:///C:/OBS-VakyaCast/bible_lower_third_studio.html?mode=dock'
                    uuid  = [System.Guid]::NewGuid().ToString('N')
                })
                $jsonStr = ConvertTo-Json -InputObject $docks -Compress
                $newLines += ('ExtraBrowserDocks=' + $jsonStr)
            }
            [System.IO.File]::WriteAllLines($ini, $newLines, (New-Object System.Text.UTF8Encoding($false)))
        }
    }

    # 2. Update existing VakyaCast / Lower Thirds Browser Sources in OBS scene collections
    $sceneFiles = Get-ChildItem (Join-Path $obsData 'basic\scenes\*.json') -ErrorAction SilentlyContinue
    foreach ($sf in $sceneFiles) {
        if ($sf.Name.EndsWith('.bak')) { continue }
        try {
            $content = Get-Content $sf.FullName -Raw -Encoding UTF8 | ConvertFrom-Json
            $changed = $false
            foreach ($src in $content.sources) {
                if ($src.id -eq 'browser_source' -and ($src.name -eq 'Lower Thirds' -or $src.name -like '*VakyaCast*' -or ($src.settings.url -like '*VakyaCast*'))) {
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
                $jsonOut = $content | ConvertTo-Json -Depth 20
                [System.IO.File]::WriteAllText($sf.FullName, $jsonOut, (New-Object System.Text.UTF8Encoding($false)))
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
    $urlContent = "[InternetShortcut]`r`nURL=file:///C:/OBS-VakyaCast/bible_lower_third_studio.html`r`n"
    [System.IO.File]::WriteAllText($studioUrlPath, $urlContent, (New-Object System.Text.UTF8Encoding($false)))

    $wsh = New-Object -ComObject WScript.Shell
    $bridgeLnk = $wsh.CreateShortcut((Join-Path $desktop 'VakyaCast HTTP Bridge (Port 8765).lnk'))
    $bridgeLnk.TargetPath = 'C:\OBS-VakyaCast\Start-Browser-To-OBS-Bridge.bat'
    $bridgeLnk.WorkingDirectory = 'C:\OBS-VakyaCast'
    $bridgeLnk.Description = 'Start VakyaCast Cross-Browser HTTP Bridge'
    $bridgeLnk.Save()
    Write-Host '  [+] Desktop Shortcuts created.'
}
