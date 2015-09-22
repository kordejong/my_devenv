cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/gnu_make.sh
export MAKEFLAGS="$MAKEFLAGS -j4"
export PATH="/cygdrive/c/Program Files (x86)/CMake/bin:$PATH"
