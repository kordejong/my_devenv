cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/gnu_make.sh
export MAKEFLAGS="$MAKEFLAGS -j20"
export PATH=/opt/local/bin:/opt/git/bin:/opt/cmake/bin:/opt/doxygen/bin:$PATH

# scl enable devtoolset-8 bash
source /opt/rh/devtoolset-8/enable
