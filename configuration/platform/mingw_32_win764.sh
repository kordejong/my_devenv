cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/32_win764.sh
export PATH="/cygdrive/c/Qt/Qt5.3.2/Tools/mingw482_32/bin:$VS90COMNTOOLS/../../VC/BIN:$PATH"
export CC=i686-w64-mingw32-gcc
export CXX=i686-w64-mingw32-g++
