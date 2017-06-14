cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/cartesius.sh
export CC=icc
export CXX=icpc
