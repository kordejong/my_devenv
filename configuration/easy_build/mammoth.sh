# Order matters!

# - Source this file
# - Configure for LUE build
# - Start / attach tmux session

# $ source ./mammoth.sh
# $ lue
# $ tmux new-session -A -s lue

module load foss2025a
module load OpenMPI

module load \
    Boost \
    CMake \
    Doxygen \
    GDAL \
    Graphviz \
    HDF5 \
    LLVM \
    Ninja \
    nodejs \
    PAPI \
    Pandoc \
    Python \
    ccache \
    gperftools \
    hwloc \
    matplotlib \
    mold \
    nlohmann_json \
    tmux
