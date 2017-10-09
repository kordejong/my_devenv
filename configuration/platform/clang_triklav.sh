cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/triklav.sh
export CC=/opt/local/bin/clang-mp-5.0
export CXX=/opt/local/bin/clang++-mp-5.0
