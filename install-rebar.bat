@echo off

git clone https://github.com/aeternity/testnet.git .

rem getting parent directory name
for %%i in ("%~dp0..") do set "folder=%%~fi"

IF EXIST "%folder%/rebar" (
	echo "Rebar already downloaded"
) else (
	git clone https://github.com/rebar/rebar .
)

rem putting rebar into testnet root dir

IF EXIST "rebar" (
	echo "Rebar bootstrap already run"
) else (
	call rebar/bootstrap.bat
)

git clone https://github.com/aeternity/testnet.git
