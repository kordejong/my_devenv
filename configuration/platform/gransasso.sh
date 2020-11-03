cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/gnu_make.sh
export MAKEFLAGS="$MAKEFLAGS -j7"
# export CLANG_FORMAT_PY=/usr/share/clang/clang-format-5.0/clang-format.py
