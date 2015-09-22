cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/gransasso.sh
# export CC=/opt/gcc-4.9/bin/gcc
# export CXX=/opt/gcc-4.9/bin/g++
# export LD_LIBRARY_PATH=/opt/gcc-4.9/lib64:$LD_LIBRARY_PATH
export CC=gcc-4.9
export CXX=g++-4.9
