cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/gransasso.sh
export CC=x86_64-w64-mingw32-gcc
export CXX=x86_64-w64-mingw32-g++
