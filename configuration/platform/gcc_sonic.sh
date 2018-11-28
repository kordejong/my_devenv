cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/sonic.sh
source /opt/rh/devtoolset-7/enable
export CC=gcc
export CXX=g++
