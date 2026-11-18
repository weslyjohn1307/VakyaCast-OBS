<#
.SYNOPSIS
  Compiles the 66 Telugu O.V. (BSI) and 66 English KJV JSON books into zero-CORS JavaScript bundles
  (telugu_ov_bundle.js and english_kjv_bundle.js) so VakyaCast LT works 100% locally offline on file:/// in OBS Studio.
#>
param(
  [string]$BibleRoot = "C:\OBS-VakyaCast\bibles",
  [string]$MirrorRoot = ""
)

$ErrorActionPreference = "Stop"

$Books = @(
  @{ id = 1;  en = "Genesis" },
  @{ id = 2;  en = "Exodus" },
  @{ id = 3;  en = "Leviticus" },
  @{ id = 4;  en = "Numbers" },
  @{ id = 5;  en = "Deuteronomy" },
  @{ id = 6;  en = "Joshua" },
  @{ id = 7;  en = "Judges" },
  @{ id = 8;  en = "Ruth" },
  @{ id = 9;  en = "1 Samuel" },
  @{ id = 10; en = "2 Samuel" },
  @{ id = 11; en = "1 Kings" },
  @{ id = 12; en = "2 Kings" },
  @{ id = 13; en = "1 Chronicles" },
  @{ id = 14; en = "2 Chronicles" },
  @{ id = 15; en = "Ezra" },
  @{ id = 16; en = "Nehemiah" },
  @{ id = 17; en = "Esther" },
  @{ id = 18; en = "Job" },
  @{ id = 19; en = "Psalms" },
  @{ id = 20; en = "Proverbs" },
  @{ id = 21; en = "Ecclesiastes" },
  @{ id = 22; en = "Song of Solomon"; teName = "Song of Songs" },
  @{ id = 23; en = "Isaiah" },
  @{ id = 24; en = "Jeremiah" },
  @{ id = 25; en = "Lamentations" },
  @{ id = 26; en = "Ezekiel" },
  @{ id = 27; en = "Daniel" },
  @{ id = 28; en = "Hosea" },
  @{ id = 29; en = "Joel" },
  @{ id = 30; en = "Amos" },
  @{ id = 31; en = "Obadiah" },
  @{ id = 32; en = "Jonah" },
  @{ id = 33; en = "Micah" },
  @{ id = 34; en = "Nahum" },
  @{ id = 35; en = "Habakkuk" },
  @{ id = 36; en = "Zephaniah" },
  @{ id = 37; en = "Haggai" },
  @{ id = 38; en = "Zechariah" },
  @{ id = 39; en = "Malachi" },
  @{ id = 40; en = "Matthew" },
  @{ id = 41; en = "Mark" },
  @{ id = 42; en = "Luke" },
  @{ id = 43; en = "John" },
  @{ id = 44; en = "Acts" },
  @{ id = 45; en = "Romans" },
  @{ id = 46; en = "1 Corinthians" },
  @{ id = 47; en = "2 Corinthians" },
  @{ id = 48; en = "Galatians" },
  @{ id = 49; en = "Ephesians" },
  @{ id = 50; en = "Philippians" },
  @{ id = 51; en = "Colossians" },
  @{ id = 52; en = "1 Thessalonians" },
  @{ id = 53; en = "2 Thessalonians" },
  @{ id = 54; en = "1 Timothy" },
  @{ id = 55; en = "2 Timothy" },
  @{ id = 56; en = "Titus" },
  @{ id = 57; en = "Philemon" },
  @{ id = 58; en = "Hebrews" },
  @{ id = 59; en = "James" },
  @{ id = 60; en = "1 Peter" },
  @{ id = 61; en = "2 Peter" },
  @{ id = 62; en = "1 John" },
  @{ id = 63; en = "2 John" },
  @{ id = 64; en = "3 John" },
  @{ id = 65; en = "Jude" },
  @{ id = 66; en = "Revelation" }
)

function Build-Bundle {
  param(
    [string]$FolderPath,
    [string]$GlobalVarName,
    [string]$OutFilePath,
    [bool]$IsTelugu
  )

  $bundle = [ordered]@{}
  $loadedBooks = 0
  $totalVerses = 0

  foreach ($b in $Books) {
    $baseName = if ($IsTelugu -and $b.ContainsKey("teName")) { $b.teName } else { $b.en }
    $candidates = @(
      (Join-Path $FolderPath ($baseName + ".json")),
      (Join-Path $FolderPath (($baseName -replace '\s+', '') + ".json")),
      (Join-Path $FolderPath ($b.en + ".json")),
      (Join-Path $FolderPath (($b.en -replace '\s+', '') + ".json"))
    )

    $foundFile = $null
    foreach ($c in $candidates) {
      if (Test-Path $c -PathType Leaf) {
        $foundFile = $c
        break
      }
    }

    if (-not $foundFile) {
      Write-Warning "Missing JSON for Book #$($b.id) ($baseName) in $FolderPath"
      continue
    }

    $rawJson = [System.IO.File]::ReadAllText($foundFile, [System.Text.Encoding]::UTF8)
    $parsed = $rawJson | ConvertFrom-Json
    $bookMap = [ordered]@{}

    if ($parsed.chapters) {
      foreach ($chObj in $parsed.chapters) {
        $chKey = [string]$chObj.chapter
        $chMap = [ordered]@{}
        if ($chObj.verses) {
          foreach ($vObj in $chObj.verses) {
            $vKey = [string]$vObj.verse
            $vText = ([string]$vObj.text).Trim()
            $chMap[$vKey] = $vText
            $totalVerses++
          }
        }
        $bookMap[$chKey] = $chMap
      }
    }

    $bundle[[string]$b.id] = $bookMap
    $loadedBooks++
  }

  $jsonPayload = $bundle | ConvertTo-Json -Depth 6 -Compress
  $jsContent = "window.$GlobalVarName=$jsonPayload;"
  $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
  [System.IO.File]::WriteAllText($OutFilePath, $jsContent, $utf8NoBom)

  $sizeMB = ([System.IO.FileInfo]$OutFilePath).Length / 1MB
  Write-Host ("[OK] {0}: {1}/66 books, {2} verses -> {3} ({4:N2} MB)" -f $GlobalVarName, $loadedBooks, $totalVerses, $OutFilePath, $sizeMB) -ForegroundColor Green
}

$teFolder = Join-Path $BibleRoot "telugu_ov"
$enFolder = Join-Path $BibleRoot "english_kjv"

if (!(Test-Path $teFolder) -or !(Test-Path $enFolder)) {
  throw "Bible folders not found in $BibleRoot. Run Download-Full-Bibles-Offline.bat first."
}

$teOut = Join-Path $BibleRoot "telugu_ov_bundle.js"
$enOut = Join-Path $BibleRoot "english_kjv_bundle.js"

Build-Bundle -FolderPath $teFolder -GlobalVarName "VAKYACAST_OFFLINE_BIBLE_TE" -OutFilePath $teOut -IsTelugu $true
Build-Bundle -FolderPath $enFolder -GlobalVarName "VAKYACAST_OFFLINE_BIBLE_EN" -OutFilePath $enOut -IsTelugu $false

if ($MirrorRoot -and (Test-Path $MirrorRoot)) {
  Copy-Item $teOut (Join-Path $MirrorRoot "telugu_ov_bundle.js") -Force
  Copy-Item $enOut (Join-Path $MirrorRoot "english_kjv_bundle.js") -Force
  Write-Host "[OK] Mirrored offline bundles to $MirrorRoot" -ForegroundColor Cyan
}
