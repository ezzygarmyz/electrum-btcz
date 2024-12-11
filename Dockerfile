
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
    software-properties-common \
    build-essential \
    python3-pyqt5 \
    pyqt5-dev-tools \
    protobuf-compiler \
    python3-setuptools \
    libusb-1.0-0-dev \
    libzbar0 \
    git && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y python3.9 python3.9-venv python3.9-dev

RUN git clone https://github.com/ezzygarmyz/electrum-btcz.git /app

WORKDIR /app

RUN python3.9 -m venv env && \
    . ./env/bin/activate && \
    pip install PyQt5

RUN command -v pyrcc5 >/dev/null 2>&1 || { echo "ERROR: pyrcc5 not found. Make sure PyQt5 is installed."; exit 1; }

RUN protoc --proto_path=lib/ --python_out=lib/ lib/paymentrequest.proto

RUN pyrcc5 icons.qrc -o gui/qt/icons_rc.py

RUN . ./env/bin/activate && pip install .[full] && pyinstaller deterministic.spec

