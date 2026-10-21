# Order matters!

# - Source this file
# - Configure for LUE build
# - Start / attach tmux session

# $ source ./mammoth.sh
# $ lue
# $ tmux new-session -A -s lue

# module load foss2025a
module load foss2026.1
module load OpenMPI

# gperftools
# mimalloc
# LLVM

module load \
    Boost \
    ccache \
    CMake \
    Doxygen \
    GDAL \
    Graphviz \
    HDF5 \
    jemalloc \
    Ninja \
    nodejs \
    PAPI \
    Python \
    hwloc \
    matplotlib \
    mold \
    nlohmann_json \
    Pandoc \
    tmux
