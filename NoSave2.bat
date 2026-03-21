@echo off
setlocal
title GTA NO-SAVE ULTIMATE
set "ruleName=GTANoSAVE_Strong"

:: Проверка прав админа
net session >nul 2>&1
if %errorlevel% neq 0 (echo RUN AS ADMIN! & pause & exit)

:menu
cls
echo ===========================================
echo    GTA Online NoSave + Overlay FIXED
echo ===========================================
netsh advfirewall firewall show rule name="%ruleName%" >nul 2>&1
if %errorlevel% == 0 (
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

if "%opt%"=="1" goto enable
if "%opt%"=="2" goto disable
if "%opt%"=="3" exit
goto menu

:enable
:: 1. Блокировка интернета
netsh advfirewall firewall add rule name="%ruleName%" dir=out action=block remoteip=192.81.240.0/20
netsh advfirewall firewall add rule name="%ruleName%" dir=in action=block remoteip=192.81.240.0/20
netsh advfirewall firewall add rule name="%ruleName%" dir=out action=block protocol=UDP localport=6672,61455-61458

:: 2. Запуск окна с принудительной загрузкой библиотек
start /min powershell -WindowStyle Hidden -Command ^
    "Add-Type -AssemblyName System.Windows.Forms; Add-Type -AssemblyName System.Drawing; " ^
    "$form = New-Object Windows.Forms.Form; $form.Text = 'NOSAVE_WINDOW'; $form.Size = New-Object Drawing.Size(200,60); " ^
    "$form.StartPosition = 'Manual'; $form.Location = New-Object Drawing.Point([System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea.Width - 210, 50); " ^
    "$form.FormBorderStyle = 'None'; $form.BackColor = 'White'; $form.TopMost = $true; " ^
    "$label = New-Object Windows.Forms.Label; $label.Text = 'NO SAVE ENABLED'; $label.Font = New-Object Drawing.Font('Arial',12,[System.Drawing.FontStyle]::Bold); " ^
    "$label.AutoSize = $true; $label.Location = New-Object Drawing.Point(10,15); $form.Controls.Add($label); " ^
    "$form.ShowDialog()"

echo [OK] NO-SAVE ACTIVE
timeout /t 1 >nul
goto menu

:disable
:: 1. Разблокировка
netsh advfirewall firewall delete rule name="%ruleName%" >nul 2>&1

:: 2. Закрытие окна по заголовку
powershell -Command "Get-Process | Where-Object {$_.MainWindowTitle -eq 'NOSAVE_WINDOW'} | Stop-Process -Force" >nul 2>&1

echo [OK] NO-SAVE DISABLED
timeout /t 1 >nul
goto menu

