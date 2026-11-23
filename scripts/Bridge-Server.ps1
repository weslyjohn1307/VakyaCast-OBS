# VakyaCast Cross-Browser HTTP Sync Bridge (Port 8765) — /sync, /state, /prefs, /backgrounds-list & static files
$l = New-Object System.Net.HttpListener
$l.Prefixes.Add('http://localhost:8765/')
$l.Prefixes.Add('http://127.0.0.1:8765/')
$l.Start()

$baseDir = if (Test-Path (Join-Path $PSScriptRoot 'bible_lower_third_studio.html')) { $PSScriptRoot } else { 'C:\OBS-VakyaCast' }
$bgDir = Join-Path $baseDir 'backgrounds'
if (!(Test-Path $bgDir)) { try { New-Item -ItemType Directory -Path $bgDir -Force | Out-Null } catch {} }

$state = '{"isLive":false}'
$prefsFile = Join-Path $baseDir 'vakyacast_prefs.json'
$prefs = if (Test-Path $prefsFile) { [System.IO.File]::ReadAllText($prefsFile) } else { '{}' }
$utf8 = New-Object System.Text.UTF8Encoding($false)

Write-Host '[READY] Control URL:     http://localhost:8765/bible_lower_third_studio.html' -ForegroundColor Green
Write-Host '[READY] OBS Overlay URL: http://localhost:8765/bible_lower_third_studio.html?mode=overlay' -ForegroundColor Cyan
Write-Host ("[READY] Backgrounds Dir: " + $bgDir) -ForegroundColor DarkCyan

while ($l.IsListening) {
    $ctx = $l.GetContext()
    $req = $ctx.Request
    $res = $ctx.Response
    $res.Headers.Add('Access-Control-Allow-Origin', '*')
    $res.Headers.Add('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
    $res.Headers.Add('Access-Control-Allow-Headers', 'Content-Type, Range')

    if ($req.HttpMethod -eq 'OPTIONS') {
        $res.StatusCode = 200
        $res.Close()
        continue
    }

    if ($req.Url.AbsolutePath -eq '/sync' -and $req.HttpMethod -eq 'POST') {
        $sr = New-Object System.IO.StreamReader($req.InputStream, [System.Text.Encoding]::UTF8)
        $state = $sr.ReadToEnd()
        $buf = $utf8.GetBytes('{"ok":true}')
        $res.ContentType = 'application/json'
        $res.OutputStream.Write($buf, 0, $buf.Length)
        $res.Close()
        continue
    }
    if ($req.Url.AbsolutePath -eq '/state') {
        $buf = $utf8.GetBytes($state)
        $res.ContentType = 'application/json'
        $res.OutputStream.Write($buf, 0, $buf.Length)
        $res.Close()
        continue
    }
    if ($req.Url.AbsolutePath -eq '/prefs' -and $req.HttpMethod -eq 'POST') {
        $sr = New-Object System.IO.StreamReader($req.InputStream, [System.Text.Encoding]::UTF8)
        $prefs = $sr.ReadToEnd()
        try { [System.IO.File]::WriteAllText($prefsFile, $prefs, $utf8) } catch {}
        $buf = $utf8.GetBytes('{"ok":true}')
        $res.ContentType = 'application/json'
        $res.OutputStream.Write($buf, 0, $buf.Length)
        $res.Close()
        continue
    }
    if ($req.Url.AbsolutePath -eq '/prefs') {
        $buf = $utf8.GetBytes($prefs)
        $res.ContentType = 'application/json'
        $res.OutputStream.Write($buf, 0, $buf.Length)
        $res.Close()
        continue
    }
    if ($req.Url.AbsolutePath -eq '/backgrounds-list') {
        $items = @()
        if (Test-Path $bgDir) {
            $files = Get-ChildItem -Path $bgDir -File | Where-Object { $_.Extension -match '^\.(mp4|webm|jpg|jpeg|png|webp|svg)$' } | Sort-Object Name
            foreach ($f in $files) {
                $kind = if ($f.Extension -match '^\.(mp4|webm)$') { 'video' } else { 'image' }
                $items += [PSCustomObject]@{
                    name = $f.Name
                    url  = '/backgrounds/' + [System.Uri]::EscapeDataString($f.Name)
                    kind = $kind
                    size = $f.Length
                }
            }
        }
        $json = if ($items.Count -eq 0) { '[]' } elseif ($items.Count -eq 1) { '[' + ($items[0] | ConvertTo-Json -Compress) + ']' } else { ($items | ConvertTo-Json -Compress) }
        $buf = $utf8.GetBytes($json)
        $res.ContentType = 'application/json; charset=utf-8'
        $res.OutputStream.Write($buf, 0, $buf.Length)
        $res.Close()
        continue
    }

    $rawPath = [System.Uri]::UnescapeDataString($req.Url.AbsolutePath.TrimStart('/'))
    $file = Join-Path $baseDir $rawPath
    if (!(Test-Path $file)) { $file = Join-Path $PSScriptRoot $rawPath }
    if (Test-Path $file -PathType Leaf) {
        $ext = [System.IO.Path]::GetExtension($file).ToLowerInvariant()
        $mime = switch ($ext) {
            '.json' { 'application/json; charset=utf-8' }
            '.js'   { 'application/javascript; charset=utf-8' }
            '.css'  { 'text/css; charset=utf-8' }
            '.mp4'  { 'video/mp4' }
            '.webm' { 'video/webm' }
            '.png'  { 'image/png' }
            '.jpg'  { 'image/jpeg' }
            '.jpeg' { 'image/jpeg' }
            '.webp' { 'image/webp' }
            '.svg'  { 'image/svg+xml' }
            default { 'text/html; charset=utf-8' }
        }
        $res.ContentType = $mime
        $res.Headers.Add('Accept-Ranges', 'bytes')
        $bytes = [System.IO.File]::ReadAllBytes($file)
        $total = $bytes.Length
        $rangeHdr = $req.Headers['Range']
        if ($rangeHdr -and $rangeHdr -match 'bytes=(\d+)-(\d*)') {
            $start = [int]$matches[1]
            $end = if ($matches[2]) { [Math]::Min([int]$matches[2], $total - 1) } else { $total - 1 }
            $len = $end - $start + 1
            $res.StatusCode = 206
            $res.Headers.Add('Content-Range', "bytes $start-$end/$total")
            $res.ContentLength64 = $len
            $res.OutputStream.Write($bytes, $start, $len)
        } else {
            $res.ContentLength64 = $total
            $res.OutputStream.Write($bytes, 0, $total)
        }
    } else {
        $res.StatusCode = 404
    }
    $res.Close()
}
