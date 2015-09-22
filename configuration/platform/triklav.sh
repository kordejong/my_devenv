cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/gnu_make.sh
export MAKEFLAGS="$MAKEFLAGS -j4"
