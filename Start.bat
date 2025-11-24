@echo off
chcp 65001 >nul
color 0D
title FISD Network Tools

setlocal EnableExtensions EnableDelayedExpansion

:: ===== INICIO =====
goto menu

:menu
cls
echo.
echo              ███████╗██╗███████╗██████╗ 
echo              ██╔════╝██║██╔════╝██╔══██╗
echo              █████╗  ██║███████╗██║  ██║
echo              ██╔══╝  ██║╚════██║██║  ██║
echo              ██║     ██║███████║██████╔╝
echo              ╚═╝     ╚═╝╚══════╝╚═════╝ 
echo.
echo =================== MENU PRINCIPAL ====================
echo.
echo A. Varredura de Rede
echo B. Geolocalização de IP
echo C. Teste de Ping Rápido (DOS)
echo D. Scanner de Portas
echo E. Rota de Comunicação (Traceroute)
echo F. Scanner de IPs Ativos (ARP)
echo G. Varredura de Rede (Ping Sweep)
echo H. Monitor de Latência Contínua
echo I. Teste de Velocidade LAN (Estatístico)
echo J. DNS Lookup Completo + WHOIS
echo K. Info de Rede / Gateway / DNS / MAC
echo L. Teste de Internet (3 Hosts)
echo M. Monitor de Porta até Abrir
echo N. Tabela ARP Completa
echo O. Sniffer de Rotas (30s)
echo P. Descobrir IP Externo(API)
echo Q. Descobrir Localização IP Externo(API)
echo R. Internet Connection Benchmark + Optimization Tool
echo S. Teste IPV4
echo T. Sair
echo.

choice /c ABCDEFGHIJKLMNOPQRST /n /m "Escolha uma opção (A-R): "
set opt=%errorlevel%

:: Mapear errorlevel para funções
if %opt%==1 goto configurar_rede
if %opt%==2 goto geolocation
if %opt%==3 goto dos
if %opt%==4 goto portscan
if %opt%==5 goto traceroute
if %opt%==6 goto arp_scan
if %opt%==7 goto ping_sweep
if %opt%==8 goto latency_monitor
if %opt%==9 goto lan_speed
if %opt%==10 goto dns_lookup
if %opt%==11 goto netinfo
if %opt%==12 goto internet_test
if %opt%==13 goto port_monitor
if %opt%==14 goto arp_table
if %opt%==15 goto route_sniffer
if %opt%==16 goto external_ip
if %opt%==17 goto external_ip_geo
if %opt%==18 goto optimize_network
if %opt%==19 goto teste
if %opt%==20 goto end

goto menu

:: ========================================================
::            		  FUNÇÕES
:: ========================================================

:configurar_rede
cls
echo ========= Verificação de Latência com Ping =========
echo.
echo Executando script de Verificação de Latência com Ping...
echo.

:: Chama o Script Externo de Verificação de Latência com Ping
start cmd /k configurar_rede.bat

echo.
echo Script finalizado. Retornando ao menu...
pause
goto menu

:geolocation
cls
echo ========= GEOLOCALIZAÇÃO DE IP =========
echo.
set /p ip=Digite o IP desejado: 
echo.
echo Consultando informações públicas do IP...
echo.
powershell -Command "Invoke-RestMethod -Uri 'https://ipinfo.io/%ip%/json' | ConvertTo-Json"
echo.
pause
goto menu

:dos
cls
echo ========= TESTE DE PING RÁPIDO =========
echo.
set /p ip=Digite o IP para testar comunicação: 
set /p count=Quantidade de envios (ex: 50): 
echo.
echo Iniciando teste de ping rápido para %ip%...
echo.
for /L %%i in (1,1,%count%) do (
    echo Tentativa %%i:
    ping -n 1 %ip% | findstr /i "Resposta Reply"
)
echo.
pause
goto menu

:portscan
cls
echo ========= SCANNER DE PORTAS =========
echo.
set /p ip=Digite o IP do alvo: 
set /p ports=Digite as portas (ex: 80,443,21): 
echo.
echo Verificando portas em %ip%...
echo.
powershell -Command "
$ip = '%ip%'
$ports = '%ports%' -split ',' 
foreach ($port in $ports) {
    $tcp = Test-NetConnection -ComputerName $ip -Port $port
    if ($tcp.TcpTestSucceeded) {
        Write-Output \"Porta $port está ABERTA\"
    } else {
        Write-Output \"Porta $port está FECHADA\"
    }
} "
echo.
pause
goto menu

:traceroute
cls
echo ========= TRACEROUTE =========
echo.
set /p ip=Digite o IP para rastrear rota: 
echo.
tracert %ip%
echo.
pause
goto menu

:arp_scan
cls
echo ========= SCANNER ARP =========
echo.
arp -a
echo.
pause
goto menu

:ping_sweep
cls
echo ========= VARREDURA DE REDE (PING SWEEP) =========
echo.
set /p base=Base da rede (ex: 192.168.1): 
echo.
echo Iniciando varredura (1 → 254)...
echo.
for /L %%i in (1,1,254) do (
    ping -n 1 %base%.%%i >nul
    if !errorlevel! == 0 (
        echo ONLINE: %base%.%%i
    )
)
echo.
pause
goto menu

:latency_monitor
cls
echo ========= MONITOR DE LATÊNCIA =========
echo.
set /p ip=IP para monitorar: 
echo.
echo Pressione CTRL + C para parar.
echo.
:lat_loop
for /f "tokens=4 delims==" %%a in ('ping -n 1 %ip% ^| find "ms"') do (
    echo [%date% %time%] Latência: %%a
)
goto lat_loop

:lan_speed
cls
echo ========= TESTE DE VELOCIDADE LAN =========
echo.
set /p ip=IP alvo: 
echo.
ping -n 20 %ip%
pause
goto menu

:dns_lookup
cls
echo ========= DNS LOOKUP COMPLETO =========
echo.
set /p target=Digite hostname ou IP: 
echo.
nslookup %target%
echo.
powershell -Command "whois %target% 2>$null"
pause
goto menu

:netinfo
cls
echo ========= INFORMAÇÕES DE REDE =========
echo.
ipconfig /all
pause
goto menu

:internet_test
cls
echo ========= TESTE DE INTERNET =========
echo.
ping -n 1 8.8.8.8
ping -n 1 1.1.1.1
ping -n 1 208.67.222.222
pause
goto menu

:port_monitor
cls
echo ========= MONITOR DE PORTA =========
echo.
set /p ip=IP alvo: 
set /p port=Porta alvo: 
echo.
echo Aguardando porta abrir...
echo CTRL + C para parar.
echo.
:pm_loop
powershell -Command "$r = Test-NetConnection -ComputerName '%ip%' -Port %port%; if ($r.TcpTestSucceeded -eq \$true) { exit 0 } else { exit 1 }"
if %errorlevel%==0 (
    echo A PORTA %port% ABRIU!
    pause
    goto menu
)
echo Porta ainda fechada...
ping 127.0.0.1 -n 2 >nul
goto pm_loop

:arp_table
cls
echo ========= TABELA ARP =========
echo.
arp -a
pause
goto menu

:route_sniffer
cls
echo ========= SNIFFER DE ROTAS (30s) =========
echo.
set /p ip=IP alvo: 
echo.
echo Coletando rotas por 30 segundos...
echo.
for /L %%i in (1,1,6) do (
    tracert -h 15 %ip%
    echo --------------------------
    ping 127.0.0.1 -n 5 >nul
)
echo.
pause
goto menu

:external_ip
cls
echo ========= DESCOBRIR IP EXTERNO =========
echo.
echo Escolha a API:
echo.
echo 1. api.ipify.org
echo 2. ifconfig.me
echo 3. ipinfo.io/ip
echo.
set /p api=Escolha (1-3): 

if "%api%"=="1" set url=https://api.ipify.org
if "%api%"=="2" set url=https://ifconfig.me
if "%api%"=="3" set url=https://ipinfo.io/ip

cls
echo Consultando IP externo usando:
echo %url%
echo.
powershell -Command "(Invoke-WebRequest '%url%' -UseBasicParsing).Content"
echo.
pause
goto menu

:external_ip_geo
cls
echo ========= GEOLOCALIZAÇÃO DO IP EXTERNO =========
echo.
echo Escolha a API:
echo.
echo 1. ipinfo.io
echo 2. ip-api.com/json
echo 3. ipgeolocation.io/ipgeo (sem chave gratuita pode limitar)
echo.
set /p api=Escolha (1-3): 

if "%api%"=="1" set url=https://ipinfo.io/json
if "%api%"=="2" set url=http://ip-api.com/json
if "%api%"=="3" set url=https://api.ipgeolocation.io/ipgeo?apiKey=FREE_KEY

cls
echo Consultando geolocalização do IP externo usando:
echo %url%
echo.
powershell -Command "Invoke-RestMethod -Uri '%url%' | ConvertTo-Json"
echo.
pause
goto menu

:optimize_network
cls
echo ==== Internet Connection Benchmark + Optimization Tool ====
echo.
echo Resetting Winsock...
netsh winsock reset >nul
echo Resetting IP settings...
netsh int ip reset >nul
echo Flushing DNS cache...
ipconfig /flushdns >nul

echo.
echo Restarting network interfaces...
rem Adjust the adapter names if yours differ (e.g., "Wireless Network Connection")
netsh interface set interface "Wi-Fi" admin=disable >nul
timeout /t 2 /nobreak >nul
netsh interface set interface "Wi-Fi" admin=enable >nul
netsh interface set interface "Ethernet" admin=disable >nul
timeout /t 2 /nobreak >nul
netsh interface set interface "Ethernet" admin=enable >nul
timeout /t 5 /nobreak >nul

echo.
echo NOTE: This script requires speedtest.exe (Speedtest CLI) to be available.
echo It will test various TCP settings to see which yields the highest download speed.
echo.
pause

rem Initialize “best” values
set bestInt=0
set bestSpeed=0
set bestLevel=none

rem Loop through various TCP autotuning levels.
rem (Other global TCP settings are fixed in this test.)
for %%L in (disabled highlyrestricted restricted normal experimental) do (
    echo --------------------------------------------------
    echo Testing autotuning level: %%L
    netsh int tcp set global autotuninglevel=%%L >nul
    netsh int tcp set global chimney=enabled >nul
    netsh int tcp set global rss=enabled >nul
    netsh int tcp set global congestionprovider=ctcp >nul

    echo Waiting for settings to take effect...
    timeout /t 5 /nobreak >nul

    echo Running speedtest for autotuning level %%L...
    rem Capture the line containing "Download"
    for /f "tokens=1,2,* delims=: " %%a in ('speedtest.exe ^| findstr /i "Download"') do (
        rem Assuming a line like: "Download: 9.61 Mbit/s"
        set currentSpeed=%%b
    )

    rem Remove any stray spaces from the speed string
    set currentSpeed=!currentSpeed: =!
    rem Convert currentSpeed (e.g., "9.61") into an integer by removing the decimal point.
    set currentInt=!currentSpeed:.=!
    echo Autotuning level %%L resulted in download speed: !currentSpeed! Mbit/s (Integer: !currentInt!)
    
    rem Compare the current test to the best so far
    if !currentInt! GTR !bestInt! (
        set bestInt=!currentInt!
        set bestSpeed=!currentSpeed!
        set bestLevel=%%L
    )
    echo.
    timeout /t 3 /nobreak >nul
)

echo.
echo ==========================================
echo Best autotuning level found: !bestLevel! with !bestSpeed! Mbit/s download speed.
echo Applying best settings...
netsh int tcp set global autotuninglevel=!bestLevel!
netsh int tcp set global chimney=enabled
netsh int tcp set global rss=enabled
netsh int tcp set global congestionprovider=ctcp
echo.
echo Optimization complete.
pause
goto menu

:teste
cls
echo ==== Teste IPV4 ====

setlocal enabledelayedexpansion

for /f "tokens=1,* delims=:" %%A in ('ipconfig ^| findstr /r /c:"adapter"') do (
    set "adapter_name=%%B"
    set "adapter_name=!adapter_name:~1!"
    
    echo Conexão: !adapter_name!

    for /f "tokens=2 delims=:" %%X in ('ipconfig ^| findstr "IPv4"') do (
        set "ipv4=%%X"
        set "ipv4=!ipv4:~1!"
    )

    for /f "tokens=2 delims=:" %%I in ('ipconfig ^| findstr /c:"IPv4" /c:"IPv4 Address"') do (
        set "line=%%I"
        for /f "tokens=* delims= " %%Y in ("!line!") do set ipv4=%%Y
    )

    for /f "tokens=2 delims=:" %%G in ('ipconfig ^| findstr /c:"IPv4" ^| findstr /c:"!adapter_name!"') do (
        set "ipv4=%%G"
    )

    rem método correto: filtrar bloco do adaptador isolado

    >"%temp%\_adpt.txt" ipconfig | findstr /c:"!adapter_name!"

    for /f "tokens=2 delims=:" %%Z in ('findstr /i "IPv4" "%temp%\_adpt.txt"') do (
        set "ipv4=%%Z"
        set "ipv4=!ipv4: =!"
        echo IPv4: !ipv4!
        goto next
    )

    echo IPv4: (não encontrado)
    :next
    echo.
)

endlocal

pause
goto menu

:end
exit
