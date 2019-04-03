cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/triklav.sh
export CC=/opt/local/bin/clang-mp-8.0
export CXX=/opt/local/bin/clang++-mp-8.0
