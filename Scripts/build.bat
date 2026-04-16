@echo off
setlocal enabledelayedexpansion

:: Set paths relative to script location (Scripts folder is one down from Root)
set "ROOT_DIR=%~dp0.."
set "VENV_PYTHON=%ROOT_DIR%\.venv\Scripts\python.exe"
set "SRC_DIR=%ROOT_DIR%\DrissionPage"
set "DIST_DIR=%ROOT_DIR%\dist"
set "REPO_URL=https://github.com/g1879/DrissionPage.git"

echo ===================================================
echo   DrissionPage Nuitka Automation Build Script
echo ===================================================

:: 1. Clone Repository if missing
if not exist "%SRC_DIR%\" (
    echo [+] Source directory not found. Cloning DrissionPage...
    git clone --depth 1 %REPO_URL% "%SRC_DIR%"
    if %ERRORLEVEL% neq 0 (
        echo [!] Error: Failed to clone repository. 
        echo [!] Make sure git is installed and you have internet access.
        if "%GITHUB_ACTIONS%"=="" pause
        exit /b 1
    )
)

:: Check for Virtual Environment
if not exist "%ROOT_DIR%\.venv\" (
    echo [+] Virtual environment not found. Initializing...
    python -m venv "%ROOT_DIR%\.venv"
    if %ERRORLEVEL% neq 0 (
        echo [!] Error: Failed to create virtual environment. 
        echo [!] Make sure Python is in your PATH.
        if "%GITHUB_ACTIONS%"=="" pause
        exit /b 1
    )
)

:: Ensure required directories exist
if not exist "%SRC_DIR%" (
    echo [!] Error: Source directory %SRC_DIR% not found.
    if "%GITHUB_ACTIONS%"=="" pause
    exit /b 1
)

if not exist "%DIST_DIR%" mkdir "%DIST_DIR%"

:: 1. Update/Ensure Dependencies
echo [+] Checking and updating base dependencies...
"%VENV_PYTHON%" -m pip install -q --upgrade pip
"%VENV_PYTHON%" -m pip install -q nuitka requests websocket-client tldextract lxml cssselect DownloadKit click psutil DrissionGet DrissionRecord

:: Extra check for DrissionPage requirements file if it exists
if exist "%SRC_DIR%\requirements.txt" (
    "%VENV_PYTHON%" -m pip install -q -r "%SRC_DIR%\requirements.txt"
)
if %ERRORLEVEL% neq 0 (
    echo [!] Warning: Dependency installation had some issues, continuing anyway...
)

:: 2. Run Nuitka Compilation
echo [+] Starting Nuitka compilation (Module mode)...
echo [+] This may take a few minutes. Please wait...

:: Change to source directory so Nuitka finds the package correctly
cd /d "%SRC_DIR%"

"%VENV_PYTHON%" -m nuitka ^
    --module DrissionPage ^
    --include-package=DrissionPage ^
    --lto=yes ^
    --remove-output ^
    --output-dir="%DIST_DIR%" ^
    --assume-yes-for-downloads

if %ERRORLEVEL% neq 0 (
    echo.
    echo [!] ERROR: Compilation failed!
if "%GITHUB_ACTIONS%"=="" pause
    exit /b %ERRORLEVEL%
)

echo.
echo ===================================================
echo   BUILD SUCCESSFUL!
echo ===================================================
echo [+] Compiled module: %DIST_DIR%\DrissionPage.cp313-win_amd64.pyd
echo [+] You can now use 'import DrissionPage' in your scripts.
echo.
echo [+] Try running the test script:
echo     "%VENV_PYTHON%" "%DIST_DIR%\main.py"
echo ===================================================
if "%GITHUB_ACTIONS%"=="" pause
