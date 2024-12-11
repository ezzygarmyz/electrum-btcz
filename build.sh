#!/bin/bash

sudo apt update
sudo apt install -y software-properties-common
add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install -y build-essential python3-setuptools python3.9 python3.9-venv python3.9-dev python3-pyqt5 protobuf-compiler libusb-1.0-0-dev libzbar0

echo "Checking if Python is installed..."
if ! command -v python3 &>/dev/null; then
    echo "ERROR: Python is not installed. Please install Python 3 from https://www.python.org/downloads/."
    exit 1
else
    echo "Python 3 is installed."
fi


echo "Creating virtual environment..."
python3.9 -m venv env
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to create virtual environment."
    exit 1
fi

echo "Activating virtual environment..."
source ./env/bin/activate
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to activate virtual environment."
    exit 1
fi


echo "Installing required dependencies..."
pip install PyQt5
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to install PyQt5."
    exit 1
fi

echo "Running pyrcc5 for .qrc to .py conversion..."
if ! command -v pyrcc5 &>/dev/null; then
    echo "ERROR: pyrcc5 not found. Make sure PyQt5 is installed."
    exit 1
fi

protoc --proto_path=lib/ --python_out=lib/ lib/paymentrequest.proto
pyrcc5 icons.qrc -o gui/qt/icons_rc.py
if [ $? -ne 0 ]; then
    echo "ERROR: pyrcc5 conversion failed."
    exit 1
fi


echo "Installing additional required dependencies..."
pip install .[full]
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to install full dependencies."
    exit 1
fi


echo "Running PyInstaller to package the app..."
pyinstaller deterministic.spec
if [ $? -ne 0 ]; then
    echo "ERROR: PyInstaller packaging failed."
    exit 1
fi


echo "Deactivating virtual environment..."
deactivate

echo "Script completed successfully."
