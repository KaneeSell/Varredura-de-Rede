@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

if not exist config.ini (
    echo Arquivo config.ini não encontrado.
    pause
    exit /b
)

for /f "tokens=1,2 delims==" %%A in (config.ini) do (
    if /i "%%~A"=="adapter"       set "adapter=%%~B"
    if /i "%%~A"=="ipv4"          set "ipv4=%%~B"
    if /i "%%~A"=="ip_base"       set "ip_base=%%~B"
    if /i "%%~A"=="quantidade"    set "quantidade=%%~B"
    if /i "%%~A"=="tamanho"       set "tamanho=%%~B"
)

echo =========================
echo    CONFIGURACAO ATUAL
echo =========================
echo Adaptador:   %adapter%
echo IPv4:        %ipv4%
echo Base IPv4:   %ip_base%
echo Quantidade:  %quantidade%
echo Tamanho:     %tamanho%
echo.

echo =========================
echo   Varredura da rede local
echo =========================

rem ===================================================
rem   CRIAR A PASTA DE LOGS SE NÃO EXISTIR
rem ===================================================
if not exist "logs" (
    mkdir "logs"
)

rem ===================================================
rem   GERAR NOME DO ARQUIVO BASEADO NA DATA E HORA
rem ===================================================
set "arquivoLog=logs\log_%date:~-4%-%date:~3,2%-%date:~0,2%_%time:~0,2%-%time:~3,2%.txt"

rem remover espaços do horário (Windows coloca espaço antes de hora < 10)
set "arquivoLog=%arquivoLog: =0%"

echo Criando arquivo de log: %arquivoLog%
echo === LOG INICIADO EM %date% %time% === > "%arquivoLog%"
echo. >> "%arquivoLog%"

rem ===================================================
rem   MESMA LÓGICA, SEM ALTERAR NADA
rem ===================================================
if not exist scan_ips.txt (
    echo Arquivo scan_ips.txt nao encontrado.
    echo.
) else (
    echo Lendo lista de IPs...
    echo.

    for /f "usebackq tokens=* delims=" %%I in ("scan_ips.txt") do (

        rem ping rápido
        ping -n 1 -w 50 %%I >nul
        if !errorlevel! equ 0 (
            echo %%I  [ONLINE]
            
            rem capturar estatísticas do ping
            ping -n %quantidade% -l %tamanho% %%I > tmp_ping.txt

            rem extrair somente as linhas necessárias
            for /f "tokens=* delims=" %%L in ('findstr /R /C:"Estatísticas" /C:"Pacotes" /C:"Aproximar" /C:"Mínimo" tmp_ping.txt') do (
                echo %%L >> "%arquivoLog%"
            )
			echo ================================================================= >> "%arquivoLog%"
            echo. >> "%arquivoLog%"
            
        ) else (
            echo %%I  [OFFLINE]
        )
    )
)

del tmp_ping.txt 2>nul

echo.
endlocal
pause
