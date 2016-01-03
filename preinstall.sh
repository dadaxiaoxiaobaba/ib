DIR="./import"
PDIR="../"

if [ ! -d "$DIR" ]
then
    mkdir $DIR
fi
cd $DIR
wget http://interactivebrokers.github.io/downloads/twsapi_macunix.971.01.jar
unzip twsapi_macunix.971.01.jar
cp ./IBJts/source/PosixClient/Shared/* .
cp ./IBJts/source/PosixClient/src/* .

if [ "$(uname)" = "Darwin" ]; then
sed -ie $'4i\\\n#define IB_USE_STD_STRING\n' ./EClientSocketBase.cpp
sed -ie $'4i\\\n#define IB_USE_STD_STRING\n' ./EPosixClientSocket.cpp
sed -ie 's_// LINUX_#include <unistd.h>_g' ./EPosixClientSocketPlatform.h
sed -ie 's_#include "StdAfx.h"__g' ./EClientSocketBaseImpl.h
elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then
sed -i '4i#define IB_USE_STD_STRING' ./EClientSocketBase.cpp
sed -i '4i#define IB_USE_STD_STRING' ./EPosixClientSocket.cpp
sed -i 's_// LINUX_#include <unistd.h>_g' ./EPosixClientSocketPlatform.h
sed -i 's_#include "StdAfx.h"__g' ./EClientSocketBaseImpl.h
elif [ "$(expr substr $(uname -s) 1 10)" = "MINGW32_NT" ]; then
sed -i '4i#define IB_USE_STD_STRING' ./EClientSocketBase.cpp
sed -i '4i#define IB_USE_STD_STRING' ./EPosixClientSocket.cpp
sed -i 's_// LINUX_#include <unistd.h>_g' ./EPosixClientSocketPlatform.h
sed -i 's_"StdAfx.h"_"afx.h"_g' ./EClientSocketBaseImpl.h
sed -i 's/snprintf/_snprintf/g' ./EClientSocketBaseImpl.h
fi
cd $PDIR
