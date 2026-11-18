@echo off
title VakyaCast LT - Clean Uninstaller
set "TARGET_DIR=C:\OBS-VakyaCast"
if exist "%TARGET_DIR%" rmdir /S /Q "%TARGET_DIR%"
echo [CLEANED] Removed previous C:\OBS-VakyaCast installation.
pause