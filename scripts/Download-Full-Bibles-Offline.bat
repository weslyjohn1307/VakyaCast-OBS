@echo off
title VakyaCast - Full 66-Book Telugu OV (BSI) & English KJV Offline Downloader & Bundler
set "BIBLE_DIR=C:\OBS-VakyaCast\bibles"
if not exist "%BIBLE_DIR%\telugu_ov" mkdir "%BIBLE_DIR%\telugu_ov"
if not exist "%BIBLE_DIR%\english_kjv" mkdir "%BIBLE_DIR%\english_kjv"
echo ====================================================================
echo   Downloading 66-Book Telugu O.V. Bible (BSI) & English KJV...
echo ====================================================================

curl.exe -L -o "%BIBLE_DIR%\telugu_ov.zip" "https://github.com/aruljohn/Bible-telugu/archive/refs/heads/main.zip"
curl.exe -L -o "%BIBLE_DIR%\english_kjv.zip" "https://github.com/aruljohn/Bible-kjv/archive/refs/heads/master.zip"

powershell -NoProfile -ExecutionPolicy Bypass -Command "Expand-Archive -Force '%BIBLE_DIR%\telugu_ov.zip' '%BIBLE_DIR%\te_temp'; Get-ChildItem '%BIBLE_DIR%\te_temp\*\*.*' | Copy-Item -Destination '%BIBLE_DIR%\telugu_ov' -Force; Remove-Item -Recurse -Force '%BIBLE_DIR%\te_temp', '%BIBLE_DIR%\telugu_ov.zip'; Expand-Archive -Force '%BIBLE_DIR%\english_kjv.zip' '%BIBLE_DIR%\en_temp'; Get-ChildItem '%BIBLE_DIR%\en_temp\*\*.*' | Copy-Item -Destination '%BIBLE_DIR%\english_kjv' -Force; Remove-Item -Recurse -Force '%BIBLE_DIR%\en_temp', '%BIBLE_DIR%\english_kjv.zip'"

echo.
echo [*] Building Zero-CORS Offline JavaScript Bundles for OBS file:/// ...
if exist "%~dp0Build-Offline-Bible-Bundles.ps1" (
  powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Build-Offline-Bible-Bundles.ps1" -BibleRoot "%BIBLE_DIR%"
) else if exist "C:\OBS-VakyaCast\Build-Offline-Bible-Bundles.ps1" (
  powershell -NoProfile -ExecutionPolicy Bypass -File "C:\OBS-VakyaCast\Build-Offline-Bible-Bundles.ps1" -BibleRoot "%BIBLE_DIR%"
)

echo [DONE] All 66 Books of Telugu OV (BSI) and English KJV are ready 100%% offline in C:\OBS-VakyaCast\bibles\
pause
