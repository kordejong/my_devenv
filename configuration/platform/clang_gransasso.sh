cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/gransasso.sh
export CC=clang-3.6
export CXX=clang++-3.6
