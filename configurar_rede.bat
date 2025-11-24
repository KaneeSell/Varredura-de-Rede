@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ===============================
echo       ADAPTADORES + IPv4
echo ===============================
echo.

rem gera arquivo temporário
ipconfig > "%temp%\netlist.txt"

set "adapter="
set "idx=0"

for /f "usebackq tokens=* delims=" %%L in ("%temp%\netlist.txt") do (

    rem detecta início de um adaptador (PT-BR usa 'Adaptador')
    echo %%L | findstr /i "Adaptador" >nul
    if not errorlevel 1 (
        set "line=%%L"

        rem remove ":" do final
        set "adapter=!line::=!"

        rem remove prefixo "Adaptador "
        set "adapter=!adapter:Adaptador =!"

        rem incrementa índice
        set /a idx+=1

        rem salva variável do adaptador
        set "adapter!idx!=!adapter!"

        rem só mostra
        echo !idx!. Conexão: !adapter!
    )

    rem detecta IPv4 dentro do bloco
    echo %%L | findstr /i "IPv4" >nul
    if not errorlevel 1 (
        for /f "tokens=2 delims=:" %%A in ("%%L") do (
            set "ip=%%A"
            set "ip=!ip: =!"

            rem salva ip correspondente ao adaptador atual
            set "ip!idx!=!ip!"

            echo    IPv4: !ip!
            echo.
        )
    )
)

echo.
echo =================================
echo Selecione o adaptador pelo número
echo =================================
set /p escolha=Número da interface: 

cls
echo.
echo =================================
echo  Quantidade de pacotes por ping
echo =================================
set /p quantidade=Quantidade(pacotes p/ ip): 

cls
echo.
echo =================================
echo       Tamanho dos pacotes
echo =================================
set /p tamanho=Tamanho 32 até 20000(bytes): 

cls
for /f "tokens=1-3 delims=." %%a in ("!ip%escolha%!") do (
    set "ip_base=%%a.%%b.%%c"
)
echo.
echo =================================
echo       Configurações atual
echo =================================
echo.
echo adapter=     !adapter%escolha%!
echo ipv4=        !ip%escolha%!
echo ip_base=     %ip_base%
echo quantidade=  %quantidade%
echo tamanho=     %tamanho%
rem ========================================================
rem            SALVAR EM CONFIG.INI (NOVO TRECHO)
rem ========================================================

(
    echo [Varredura de Rede]
    echo adapter=!adapter%escolha%!
    echo ipv4=!ip%escolha%!
	echo ip_base=%ip_base%
    echo quantidade=%quantidade%
    echo tamanho=%tamanho%
) > config.ini

(
	for /L %%I in (1,1,255) do (
		echo %ip_base%.%%I
	)
) > scan_ips.txt

echo.
echo Configurações salvas em config.ini
echo.

endlocal
pause
