cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/triklav.sh
export CC=mpicc-openmpi-mp
export CXX=mpicxx-openmpi-mp
