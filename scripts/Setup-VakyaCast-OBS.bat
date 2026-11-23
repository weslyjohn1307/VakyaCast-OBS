@echo off
title VakyaCast LT - Automatic OBS ^& Standalone Setup
echo ====================================================================
echo   VakyaCast Bible Lower-Third - Automatic OBS Installer ^& Repair
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
if exist "%SRC_DIR%\scripts\Bridge-Server.ps1" copy /Y "%SRC_DIR%\scripts\Bridge-Server.ps1" "%TARGET_DIR%\Bridge-Server.ps1" >nul
if exist "%SRC_DIR%\scripts\Download-Full-Bibles-Offline.bat" copy /Y "%SRC_DIR%\scripts\Download-Full-Bibles-Offline.bat" "%TARGET_DIR%\Download-Full-Bibles-Offline.bat" >nul
if exist "%SRC_DIR%\scripts\Build-Offline-Bible-Bundles.ps1" copy /Y "%SRC_DIR%\scripts\Build-Offline-Bible-Bundles.ps1" "%TARGET_DIR%\Build-Offline-Bible-Bundles.ps1" >nul
if exist "%SRC_DIR%\scripts\Configure-OBS-Integration.ps1" copy /Y "%SRC_DIR%\scripts\Configure-OBS-Integration.ps1" "%TARGET_DIR%\Configure-OBS-Integration.ps1" >nul
if exist "%SRC_DIR%\scripts\Uninstall-Previous-Setup.bat" copy /Y "%SRC_DIR%\scripts\Uninstall-Previous-Setup.bat" "%TARGET_DIR%\Uninstall-Previous-Setup.bat" >nul

if exist "%SRC_DIR%\bibles" (
  echo [*] Synchronizing offline Telugu OV ^& English KJV Bibles ...
  if not exist "%TARGET_DIR%\bibles" mkdir "%TARGET_DIR%\bibles"
  xcopy /E /I /Y /Q "%SRC_DIR%\bibles" "%TARGET_DIR%\bibles" >nul
)

echo [*] Checking and configuring OBS Studio integration ...
if exist "%TARGET_DIR%\Configure-OBS-Integration.ps1" (
  powershell -NoProfile -ExecutionPolicy Bypass -File "%TARGET_DIR%\Configure-OBS-Integration.ps1"
) else (
  powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Configure-OBS-Integration.ps1"
)

echo file:///C:/OBS-VakyaCast/bible_lower_third_studio.html?mode=dock| clip

echo.
echo ====================================================================
echo   [SUCCESS] VakyaCast LT installed to C:\OBS-VakyaCast\ !
echo   - OBS Custom Dock URL:    file:///C:/OBS-VakyaCast/bible_lower_third_studio.html?mode=dock
echo   - OBS Browser Source URL: file:///C:/OBS-VakyaCast/bible_lower_third_studio.html?mode=overlay
echo   - Desktop Shortcuts:      Created on your Desktop
echo   - Clipboard:              Dock URL copied to clipboard!
echo ====================================================================
if /I not "%~1"=="--no-pause" pause
