#!/bin/bash

VERSION_STRING=(`grep ELECTRUM_VERSION lib/version.py`)
ELECTRUM_BTCZ_VERSION=${VERSION_STRING[2]}
ELECTRUM_BTCZ_VERSION=${ELECTRUM_BTCZ_VERSION#\'}
ELECTRUM_BTCZ_VERSION=${ELECTRUM_BTCZ_VERSION%\'}
DOTS=`echo $ELECTRUM_BTCZ_VERSION |  grep -o "\." | wc -l`
if [[ $DOTS -lt 3 ]]; then
    ELECTRUM_BTCZ_APK_VERSION=$ELECTRUM_BTCZ_VERSION.0
else
    ELECTRUM_BTCZ_APK_VERSION=$ELECTRUM_BTCZ_VERSION
fi
export ELECTRUM_BTCZ_VERSION
export ELECTRUM_BTCZ_APK_VERSION