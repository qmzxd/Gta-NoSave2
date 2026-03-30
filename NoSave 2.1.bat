```batch
@echo off
setlocal enabledelayedexpansion
title GTA NO-SAVE ULTIMATE
set "ruleName=GTANoSAVE_Strong"

net session >nul 2>&1
if %errorlevel% neq 0 (echo RUN AS ADMIN! & pause & exit)

:menu
cls
echo ===========================================
echo    GTA Online NoSave + Overlay FIXED
echo ===========================================
netsh advfirewall firewall show rule name="%ruleName%" >nul 2>&1
if !errorlevel! == 0 (
    echo [ STATUS: ENABLED ]
) else (
    echo [ STATUS: DISABLED ]
)
echo.
echo 1. ENABLE NoSave (Block + Window)
echo 2. DISABLE NoSave (Unblock + Close)
echo 3. EXIT
echo.
set /p opt="Select: "

if "!opt!"=="1" goto enable
if "!opt!"=="2" goto disable
if "!opt!"=="3" goto quit
goto menu

:enable
netsh advfirewall firewall delete rule name="%ruleName%" >nul 2>&1
netsh advfirewall firewall add rule name="%ruleName%" dir=out action=block remoteip=192.81.240.0/20 >nul
netsh advfirewall firewall add rule name="%ruleName%" dir=in action=block remoteip=192.81.240.0/20 >nul
netsh advfirewall firewall add rule name="%ruleName%" dir=out action=block protocol=UDP localport=6672,61455-61458 >nul

start "" /min powershell -WindowStyle Hidden -Command "$PID | Out-File '%temp%\nosave_pid.txt'; Add-Type -AssemblyName System.Windows.Forms,System.Drawing; $form=New-Object Windows.Forms.Form; $form.Text='NOSAVE_WINDOW'; $form.Size=New-Object Drawing.Size(160,36); $form.StartPosition='Manual'; $form.Location=New-Object Drawing.Point([System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea.Width-168,40); $form.FormBorderStyle='None'; $form.BackColor='White'; $form.TopMost=$true; $label=New-Object Windows.Forms.Label; $label.Text='NO SAVE ENABLED'; $label.ForeColor='Black'; $label.Font=New-Object Drawing.Font('Arial',8,[Drawing.FontStyle]::Bold); $label.AutoSize=$false; $label.Size=New-Object Drawing.Size(160,36); $label.TextAlign='MiddleCenter'; $form.Controls.Add($label); $form.ShowDialog()"

echo [OK] NO-SAVE ACTIVE
timeout /t 1 >nul
goto menu

:disable
netsh advfirewall firewall delete rule name="%ruleName%" >nul 2>&1
powershell -Command "Get-Process powershell | Where-Object {$_.MainWindowTitle -eq 'NOSAVE_WINDOW'} | Stop-Process -Force" >nul 2>&1
if exist "%temp%\nosave_pid.txt" (
    set /p savedpid=<"%temp%\nosave_pid.txt"
    taskkill /PID !savedpid! /F >nul 2>&1
    del "%temp%\nosave_pid.txt" >nul 2>&1
)
echo [OK] NO-SAVE DISABLED
timeout /t 1 >nul
goto menu

:quit
netsh advfirewall firewall delete rule name="%ruleName%" >nul 2>&1
powershell -Command "Get-Process powershell | Where-Object {$_.MainWindowTitle -eq 'NOSAVE_WINDOW'} | Stop-Process -Force" >nul 2>&1
if exist "%temp%\nosave_pid.txt" (
    set /p savedpid=<"%temp%\nosave_pid.txt"
    taskkill /PID !savedpid! /F >nul 2>&1
    del "%temp%\nosave_pid.txt" >nul 2>&1
)
exit
```1