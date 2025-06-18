@echo off
:: Ejecutar script PowerShell como administrador
PowerShell -NoProfile -ExecutionPolicy Bypass -Command ^
"Start-Process PowerShell -ArgumentList '-ExecutionPolicy Bypass -File \"%~dp0automated apps download and install v1.ps1\"' -Verb RunAs"

