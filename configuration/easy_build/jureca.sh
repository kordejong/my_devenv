# Order matters!
# TODO:
# - UCX?
# - Compare with Junxian's modules
# - Configure use of ccache and mold

module load Stages/2025

source $PROJECT_paj2600/User_EB_files/EB_bash.sh

module load GCC OpenMPI

# module load \
#     Doxygen \
#     tmux

# Load HDF5 explicitly, and after GDAL so we get the HDF5 library supporting parallel I/O
module load \
    Clang \
    CMake/4.0.3 \
    GDAL \
    Graphviz \
    matplotlib \
    Ninja \
    Pandoc \
    ccache \
    mold \
    nlohmann_json
module load \
    HDF5

hpx_build_type=RelWithDebInfo
hpx_build_type=Debug
module load \
    HPX/1.11.0-${hpx_build_type}

echo "Loaded HPX with build type ${hpx_build_type}"

# module load HPX/1.10.0-RelDeb
# module load HPX/1.11.x-RelWithDebInfo
