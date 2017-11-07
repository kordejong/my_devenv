cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/gransasso.sh
export CC="clang-5.0"
export CXX="clang++-5.0"
