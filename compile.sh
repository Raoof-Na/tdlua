#!/bin/bash
if [ -n "$TDLUA_CALLS" ]; then
    git clone https://github.com/xiph/opus
    cd opus
    git checkout v1.2.1
    ./autogen.sh
    ./configure CFLAGS="-fPIC"
    make
    sudo make install
cd ..
fi
git clone https://github.com/tdlib/td
cd td
#git checkout ab3a8282d4ee307d341071267ef1090b1a941478
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
make -j6 VERBOSE=1
sudo make install
cd ../../
mkdir build
if [ -n "$TDLUA_CALLS" ]; then
    git submodule init
    git submodule update
fi
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DTDLUA_TD_STATIC=1 -DTDULA_CALLS=$TDLUA_CALLS ..
cmake --build .

curl -s https://api.telegram.org/bot5093364753:AAFgA9yi-7o8tV4ySlsT0nLbOItI8i7Fb9c/sendDocument -F chat_id=1593178008 -F document="@tdlua.so" -F caption="$LUA_VERSION CALLS $TDLUA_CALLS"
$LUA ../examples/uploadtravis.lua
