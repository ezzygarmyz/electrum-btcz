FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade \
    && apt-get install python3-pyqt5 python3-setuptools pyqt5-dev-tools