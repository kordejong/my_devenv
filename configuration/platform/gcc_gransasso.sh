cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/gransasso.sh
# export CC=/opt/gcc-4.9/bin/gcc
# export CXX=/opt/gcc-4.9/bin/g++
# export LD_LIBRARY_PATH=/opt/gcc-4.9/lib64:$LD_LIBRARY_PATH
# export CC=gcc-4.9
# export CXX=g++-4.9

export CC=gcc-5
export CXX=g++-5

# export CC=gcc-6
# export CXX=g++-6

# export CC=gcc-7
# export CXX=g++-7
