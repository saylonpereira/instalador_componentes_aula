@echo off
:: Lançador — executa o script PowerShell como Administrador
powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%~dp0setup-devtools.ps1""' -Verb RunAs"
