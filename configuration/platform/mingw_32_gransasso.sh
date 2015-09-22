cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/gransasso.sh
export CC=i686-w64-mingw32-gcc
export CXX=i686-w64-mingw32-g++
