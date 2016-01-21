cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/sonic.sh
export CC=/opt/gcc/bin/gcc
export CXX=/opt/gcc/bin/g++
export LD_LIBRARY_PATH=/opt/gcc/lib64:$LD_LIBRARY_PATH
