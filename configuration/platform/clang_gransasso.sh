cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/gransasso.sh
export CC="clang-5.0"
export CXX="clang++-5.0"
export CLANG_FORMAT_PY=/usr/share/clang/clang-format-5.0/clang-format.py
