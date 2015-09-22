cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/64_win764.sh
export PATH="/cygdrive/c/mingw64/bin:$VS90COMNTOOLS/../../VC/BIN/amd64:$PATH"
export CC=x86_64-w64-mingw32-gcc
export CXX=x86_64-w64-mingw32-g++
