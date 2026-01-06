# Order matters!
# TODO:
# - UCX?
# - Compare with Junxian's modules
# - Configure use of ccache and mold

source $PROJECT_paj2511/User_EB_files/EB_bash.sh

module load Stages/2025
module load GCC OpenMPI
module load \
    Boost \
    Doxygen \
    GDAL \
    Graphviz \
    HDF5 \
    Ninja \
    Pandoc \
    Python \
    ccache \
    hwloc \
    jemalloc \
    matplotlib \
    mold \
    nlohmann_json \
    tmux
module load \
    Clang \
    CMake/4.0.3
module load \
    HPX/1.11.0-RelWithDebInfo

# module load HPX/1.10.0-RelDeb
# module load HPX/1.11.x-RelWithDebInfo
