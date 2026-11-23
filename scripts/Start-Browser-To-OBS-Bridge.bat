@echo off
title VakyaCast Cross-Browser HTTP Sync Bridge (Port 8765)
echo ====================================================================
echo   VakyaCast Cross-Browser Bridge (Port 8765)
echo   Operate in Chrome/Edge/Firefox -^> Live Update in OBS Browser Source
echo ====================================================================
echo.
echo Starting built-in Windows HTTP Sync Bridge on http://localhost:8765 ...
start "" "http://localhost:8765/bible_lower_third_studio.html"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Bridge-Server.ps1"
pause
