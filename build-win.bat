@echo off

REM 

echo Checking if Python is installed...
python --version >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo ERROR: Python is not installed. Please install Python from https://www.python.org/downloads/.
    exit /b 1
) ELSE (
    echo Python is installed.
)

REM 

echo Creating virtual environment...
python -m venv env
IF %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to create virtual environment.
    exit /b 1
)

echo Activating virtual environment...
call .\env\Scripts\activate.bat
IF %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to activate virtual environment.
    exit /b 1
)

REM 

echo Installing required dependencies...
pip install pyqt5
IF %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to install PyQt5.
    exit /b 1
)

echo Running pyrcc5 for .qrc to .py conversion...
pyrcc5 icons.qrc -o gui/qt/icons_rc.py
IF %ERRORLEVEL% NEQ 0 (
    echo ERROR: pyrcc5 conversion failed.
    exit /b 1
)

echo Installing additional required dependencies...
pip install .[full]
IF %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to install full dependencies.
    exit /b 1
)

REM 

echo Running PyInstaller to package the app...
pyinstaller deterministic.spec
IF %ERRORLEVEL% NEQ 0 (
    echo ERROR: PyInstaller packaging failed.
    exit /b 1
)

REM 

echo Deactivating virtual environment...
call .\env\Scripts\deactivate.bat

REM 

set NSIS_DIR="C:\Program Files (x86)\NSIS\Bin"
if EXIST %NSIS_DIR%\makensis.exe (
    echo NSIS is installed. Compiling installer...
    %NSIS_DIR%\makensis electrum-btcz.nsi
    IF %ERRORLEVEL% NEQ 0 (
        echo ERROR: NSIS installer compilation failed.
        exit /b 1
    )
) ELSE (
    echo WARNING: NSIS is not installed. Skipping installer creation.
)

echo Script completed successfully!
pause
