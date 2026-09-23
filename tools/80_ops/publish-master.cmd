@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0publish-master.ps1" %*
pause
