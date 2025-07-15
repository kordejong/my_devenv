cwd=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source $cwd/util.sh
unset cwd

# TODO Turn into CMake settings (toolchains?), if necessary
# export MAKEFLAGS="$MAKEFLAGS --quiet"
# export CTEST_OUTPUT_ON_FAILURE=1

parse_commandline $*

if [ ! "$LUE" ]; then
    export LUE="$PROJECTS/github/computational_geography/lue"
fi

if [ ! -d "$LUE" ]; then
    echo "ERROR: directory $LUE does not exist..."
    return 1
fi

basename=$(basename $LUE)

# LUE_OBJECTS="$OBJECTS/$MY_DEVENV_BUILD_TYPE/$basename"
# LUE_DATA="$OBJECTS/../data/$MY_DEVENV_BUILD_TYPE/$basename"

PATH="\
$LUE/environment/script:\
$PATH"

LUE_HOSTNAME=$(hostname -s 2>/dev/null)

if [ ! "$LUE_HOSTNAME" ]; then
    LUE_HOSTNAME=$(hostname)
fi

if [ ! "$LUE_HOSTNAME" ]; then
    echo "Could not figure out the hostname"
    exit 1
fi

LUE_HOSTNAME="${LUE_HOSTNAME,,}" # Lower-case the hostname

if [[ $LUE_HOSTNAME == int? || $LUE_HOSTNAME == tcn* ]]; then
    LUE_HOSTNAME="snellius"
elif [[ $LUE_HOSTNAME == jr* ]]; then
    LUE_HOSTNAME="jureca"
elif [[ $LUE_HOSTNAME == wn-dc-05 ]]; then
    LUE_HOSTNAME="spider"
elif [[ $LUE_HOSTNAME == uu107273 || $LUE_HOSTNAME == uu-c07hg08bq6p0 ]]; then
    LUE_HOSTNAME="m1compiler"
elif [[ $HOME == /eejit/* ]]; then
    LUE_HOSTNAME="eejit"
fi

#   -DCMAKE_RULE_MESSAGES=OFF
# LUE_CMAKE_ARGUMENTS=""
# LUE_CMAKE_ARGUMENTS="
#     -DLUE_HPX_REPOSITORY=\"file://$PROJECTS/github/kordejong/hpx\"
# "
# This tag corresponds with HPX 1.8.0
# -DLUE_HPX_GIT_TAG=v1.9.0-rc1
# -DLUE_HPX_GIT_TAG=198cba516ea

unset basename

### repository_cache="$HOME/development/repository"
### if [ -d "$repository_cache" ]; then
###     LUE_CMAKE_ARGUMENTS="
###         $LUE_CMAKE_ARGUMENTS
###         -DLUE_REPOSITORY_CACHE:PATH=$repository_cache
###     "
### fi

### cmake_toolchain_file=$MY_DEVENV/configuration/platform/cmake/$LUE_HOSTNAME/$MY_DEVENV_BUILD_TYPE.cmake
###
### if [ ! -f $cmake_toolchain_file ]; then
###     cmake_toolchain_file=$MY_DEVENV/configuration/platform/cmake/$LUE_HOSTNAME.cmake
### fi
###
### if [ ! -f $cmake_toolchain_file ]; then
###     echo "INFO: No CMake toolchain file found for a $MY_DEVENV_BUILD_TYPE build on $LUE_HOSTNAME"
### else
###     LUE_CMAKE_ARGUMENTS="
###         $LUE_CMAKE_ARGUMENTS
###         -DCMAKE_TOOLCHAIN_FILE=$cmake_toolchain_file
###     "
### fi

if [[ $LUE_HOSTNAME == "eejit" ]]; then
    source $LUE/.venv/bin/activate
elif [[ $LUE_HOSTNAME == "gransasso" ]]; then
    ### # Platform for testing use of the Ubuntu packages of 3rd party
    ### # software LUE depends on. No LUE_HAVE_<NAME> variables set to FALSE.
    ### LUE_CMAKE_ARGUMENTS="
    ###     $LUE_CMAKE_ARGUMENTS
    ###     -DLUE_QA_TEST_NR_LOCALITIES_PER_TEST=2
    ###     -DLUE_QA_TEST_NR_THREADS_PER_LOCALITY=2
    ### "
    ### CMAKE_BUILD_PARALLEL_LEVEL=5
    # PYTHONPATH=$LUE_OBJECTS/lib:$PYTHONPATH
    ### LUE_ROUTING_DATA="/mnt/data1/home/kor/data/project/routing"
    ### LUE_BENCHMARK_DATA="/mnt/data1/home/kor/data/project/lue/benchmark/gransasso/"

    source $LUE/env/bin/activate

elif [[ $LUE_HOSTNAME == "jureca" ]]; then
    source $LUE/.venv/bin/activate

elif [[ $LUE_HOSTNAME == "orkney" ]]; then
    source $LUE/env/bin/activate

elif [[ $LUE_HOSTNAME == "fg-vm12" ]]; then
    ### if [ -d "$repository_cache" ]; then
    ###     LUE_CMAKE_ARGUMENTS="
    ###         $LUE_CMAKE_ARGUMENTS
    ###         -DLUE_REPOSITORY_CACHE:PATH=$(cygpath --mixed $repository_cache)
    ###     "
    ### fi

    ### LUE_CMAKE_ARGUMENTS="
    ###     $LUE_CMAKE_ARGUMENTS
    ###     -DCMAKE_TOOLCHAIN_FILE=$(cygpath --mixed $cmake_toolchain_file)
    ### "

    ### LUE_CMAKE_ARGUMENTS="
    ###     $LUE_CMAKE_ARGUMENTS
    ###     -DLUE_BUILD_DOCUMENTATION:BOOL=FALSE
    ###     -DLUE_QA_TEST_NR_LOCALITIES_PER_TEST=2
    ###     -DLUE_QA_TEST_NR_THREADS_PER_LOCALITY=1
    ###     -DLUE_HAVE_BOOST:BOOL=TRUE
    ###     -DLUE_HAVE_DOCOPT:BOOL=FALSE
    ###     -DLUE_HAVE_FMT:BOOL=FALSE
    ###     -DLUE_HAVE_GDAL:BOOL=TRUE
    ###     -DLUE_HAVE_GLFW:BOOL=FALSE
    ###     -DLUE_HAVE_HDF5:BOOL=TRUE
    ###     -DLUE_HAVE_NLOHMANN_JSON:BOOL=FALSE
    ###     -DLUE_HAVE_PYBIND11:BOOL=FALSE
    ### "
    ### CMAKE_BUILD_PARALLEL_LEVEL=2
    # PATH=$LUE_OBJECTS/bin/$MY_DEVENV_BUILD_TYPE:$PATH
    # PYTHONPATH=$LUE_OBJECTS/lib/$MY_DEVENV_BUILD_TYPE:$PYTHONPATH
    ### LUE_ROUTING_DATA="$HOME/not_needed_on_windows_yet"

    ### # export PATH="`cygpath --mixed /C/Program\ Files\ \(x86\)/Microsoft\ Visual\ Studio/2019/Community/VC/Tools/MSVC/14.29.30133/bin/Hostx64/x64`:$PATH"
    ### export CC=C:/PROGRA~2/MICROS~1/2019/COMMUN~1/VC/Tools/MSVC/1429~1.301/bin/Hostx64/x64/cl
    ### export CXX=C:/PROGRA~2/MICROS~1/2019/COMMUN~1/VC/Tools/MSVC/1429~1.301/bin/Hostx64/x64/cl
    ### # export CC="$(cygpath --mixed /C/Program\ Files\ \(x86\)/Microsoft\ Visual\ Studio/2019/Community/VC/Tools/MSVC/14.29.30133/bin/Hostx64/x64/cl)"
    ### # export CXX="$(cygpath --mixed /C/Program\ Files\ \(x86\)/Microsoft\ Visual\ Studio/2019/Community/VC/Tools/MSVC/14.29.30133/bin/Hostx64/x64/cl)"

    conda activate lue

### elif [[ $LUE_HOSTNAME == "ketjen" ]];
### then
###     if [ -d "$repository_cache" ]; then
###         LUE_CMAKE_ARGUMENTS="
###             $LUE_CMAKE_ARGUMENTS
###             -DLUE_REPOSITORY_CACHE:PATH=$(cygpath --mixed $repository_cache)
###         "
###     fi
###
###     LUE_CMAKE_ARGUMENTS="
###         $LUE_CMAKE_ARGUMENTS
###         -DCMAKE_TOOLCHAIN_FILE=$(cygpath --mixed $cmake_toolchain_file)
###     "
###
###     # Platform for testing use of the Conan packages of 3rd party software
###     # LUE depends on. LUE_HAVE_<NAME> variables set to FALSE.
###     LUE_CMAKE_ARGUMENTS="
###         $LUE_CMAKE_ARGUMENTS
###         -DLUE_BUILD_DOCUMENTATION:BOOL=FALSE
###         -DLUE_BUILD_FRAMEWORK:BOOL=FALSE
###         -DLUE_FRAMEWORK_WITH_PYTHON_API:BOOL=TRUE
###         -DLUE_QA_TEST_NR_LOCALITIES_PER_TEST=2
###         -DLUE_QA_TEST_NR_THREADS_PER_LOCALITY=1
###         -DLUE_HAVE_BOOST:BOOL=FALSE
###         -DLUE_HAVE_DOCOPT:BOOL=FALSE
###         -DLUE_HAVE_FMT:BOOL=FALSE
###         -DLUE_HAVE_GDAL:BOOL=FALSE
###         -DLUE_HAVE_GLFW:BOOL=FALSE
###         -DLUE_HAVE_HDF5:BOOL=FALSE
###         -DLUE_HAVE_NLOHMANN_JSON:BOOL=FALSE
###         -DLUE_HAVE_PYBIND11:BOOL=FALSE
###     "
###     CMAKE_BUILD_PARALLEL_LEVEL=2
###     PYTHONPATH=$LUE_OBJECTS/lib:$PYTHONPATH
###     LUE_ROUTING_DATA="$HOME/not_needed_on_windows_yet"
###
###     # export PATH="`cygpath --mixed /C/Program\ Files\ \(x86\)/Microsoft\ Visual\ Studio/2019/Community/VC/Tools/MSVC/14.29.30133/bin/Hostx64/x64`:$PATH"
###     export CC=C:/PROGRA~2/MICROS~1/2019/COMMUN~1/VC/Tools/MSVC/1429~1.301/bin/Hostx64/x64/cl
###     export CXX=C:/PROGRA~2/MICROS~1/2019/COMMUN~1/VC/Tools/MSVC/1429~1.301/bin/Hostx64/x64/cl
###     # export CC="$(cygpath --mixed /C/Program\ Files\ \(x86\)/Microsoft\ Visual\ Studio/2019/Community/VC/Tools/MSVC/14.29.30133/bin/Hostx64/x64/cl)"
###     # export CXX="$(cygpath --mixed /C/Program\ Files\ \(x86\)/Microsoft\ Visual\ Studio/2019/Community/VC/Tools/MSVC/14.29.30133/bin/Hostx64/x64/cl)"

elif [[ $LUE_HOSTNAME == "hoy" ]]; then
    source $LUE/env/Scripts/activate
    # eval "$($HOME/miniforge3/Scripts/conda shell.bash hook)"
    # conda activate lue_dev
elif [[ $LUE_HOSTNAME == "m1compiler" ]]; then
    # macOS platform for testing build of LUE using Conda packages. These should be installed.
    ### LUE_CMAKE_ARGUMENTS="
    ###     $LUE_CMAKE_ARGUMENTS
    ###     -DLUE_BUILD_DOCUMENTATION:BOOL=FALSE
    ###     -DLUE_QA_TEST_NR_LOCALITIES_PER_TEST=2
    ###     -DLUE_QA_TEST_NR_THREADS_PER_LOCALITY=2
    ###     -DLUE_QA_TEST_HPX_RUNWRAPPER=none
    ###     -DLUE_QA_TEST_HPX_PARCELPORT=tcp
    ### "
    ### CMAKE_BUILD_PARALLEL_LEVEL=4

    source $LUE/env/bin/activate

elif [[ $LUE_HOSTNAME == "login01" ]]; then
    # Platform for production runs.
    ### LUE_CMAKE_ARGUMENTS="
    ###     $LUE_CMAKE_ARGUMENTS
    ###     -DLUE_BUILD_VIEW:BOOL=FALSE
    ###     -DLUE_BUILD_DOCUMENTATION:BOOL=FALSE
    ###     -DLUE_HAVE_DOCOPT:BOOL=FALSE
    ###     -DLUE_HAVE_FMT:BOOL=FALSE
    ###     -DLUE_HAVE_NLOHMANN_JSON:BOOL=FALSE
    ###     -DLUE_HAVE_PYBIND11:BOOL=FALSE
    ###     -DLUE_QA_TEST_NR_LOCALITIES_PER_TEST=2
    ###     -DLUE_QA_TEST_NR_THREADS_PER_LOCALITY=3
    ###     -DLUE_QA_TEST_HPX_RUNWRAPPER=mpi
    ###     -DLUE_QA_TEST_HPX_PARCELPORT=mpi
    ### "
    ### CMAKE_BUILD_PARALLEL_LEVEL=10
    ### # PYTHONPATH=$LUE_OBJECTS/lib:$PYTHONPATH
    ### LUE_ROUTING_DATA="/scratch/depfg/jong0137/data/routing"
    ### LUE_BENCHMARK_DATA="/scratch/depfg/jong0137/data/project/lue/benchmark"

    conda activate lue

elif [[ $LUE_HOSTNAME == "snellius" ]]; then
    # Platform for production runs.
    ### LUE_CMAKE_ARGUMENTS="
    ###     $LUE_CMAKE_ARGUMENTS
    ###     -DLUE_BUILD_DOCUMENTATION:BOOL=FALSE
    ###     -DLUE_FRAMEWORK_WITH_PYTHON_API:BOOL=TRUE
    ###     -DLUE_BUILD_VIEW:BOOL=FALSE
    ###     -DLUE_HAVE_DOCOPT:BOOL=FALSE
    ###     -DLUE_HAVE_FMT:BOOL=FALSE
    ###     -DLUE_HAVE_NLOHMANN_JSON:BOOL=TRUE
    ###     -DLUE_HAVE_PYBIND11:BOOL=TRUE
    ###     -DLUE_QA_TEST_NR_LOCALITIES_PER_TEST=2
    ###     -DLUE_QA_TEST_NR_THREADS_PER_LOCALITY=3
    ###     -DLUE_QA_TEST_HPX_RUNWRAPPER=mpi
    ###     -DLUE_QA_TEST_HPX_PARCELPORT=mpi
    ### "
    ### CMAKE_BUILD_PARALLEL_LEVEL=32
    # PYTHONPATH=$LUE_OBJECTS/lib:$PYTHONPATH
    # LUE_ROUTING_DATA="/scratch/depfg/jong0137/data/routing"
    # LUE_BENCHMARK_DATA="/scratch/depfg/jong0137/data/project/lue/benchmark"

    source $LUE/env/bin/activate

elif [[ $LUE_HOSTNAME == "snowdon" ]]; then
    ### LUE_CMAKE_ARGUMENTS="
    ###     $LUE_CMAKE_ARGUMENTS
    ###     -DLUE_QA_TEST_NR_LOCALITIES_PER_TEST=2
    ###     -DLUE_QA_TEST_NR_THREADS_PER_LOCALITY=2
    ### "
    ### CMAKE_BUILD_PARALLEL_LEVEL=4
    ### # PYTHONPATH=$LUE_OBJECTS/lib:$PYTHONPATH
    ### LUE_ROUTING_DATA="$HOME/development/data/project/routing"

    source $LUE/env/bin/activate

elif [[ $LUE_HOSTNAME == "spider" ]]; then
    source $LUE/.venv/bin/activate

elif [[ $LUE_HOSTNAME == "velocity" ]]; then
    # Platform for development. All 3rd party packages should be available on the system.
    # TODO boost, gdal, hdf5
    ### LUE_CMAKE_ARGUMENTS="
    ###     $LUE_CMAKE_ARGUMENTS
    ###     -DLUE_HAVE_DOCOPT:BOOL=FALSE
    ###     -DLUE_HAVE_BOOST:BOOL=TRUE
    ###     -DLUE_HAVE_FMT:BOOL=FALSE
    ###     -DLUE_HAVE_GDAL:BOOL=TRUE
    ###     -DLUE_HAVE_GLFW:BOOL=TRUE
    ###     -DLUE_HAVE_HDF5:BOOL=TRUE
    ###     -DLUE_HAVE_NLOHMANN_JSON:BOOL=TRUE
    ###     -DLUE_HAVE_PYBIND11:BOOL=TRUE
    ###     -DLUE_QA_TEST_NR_LOCALITIES_PER_TEST=3
    ###     -DLUE_QA_TEST_NR_THREADS_PER_LOCALITY=3
    ### "
    ### CMAKE_BUILD_PARALLEL_LEVEL=10
    ### # PYTHONPATH=$LUE_OBJECTS/lib:$PYTHONPATH
    ### LUE_ROUTING_DATA="/todo/doesnotexist"

    export CONAN_USER_HOME="$PROJECTS/.."

    source $LUE/env/bin/activate

else
    echo "Unknown hostname: $LUE_HOSTNAME"
    return 1
fi

### if [[ $MY_DEVENV_BUILD_TYPE == "Debug" ]];
### then
###     LUE_CMAKE_ARGUMENTS="
###         $LUE_CMAKE_ARGUMENTS
###         -DLUE_ASSERT_CONDITIONS:BOOL=TRUE
###     "
###
###     # LUE_CMAKE_ARGUMENTS="
###     #     $LUE_CMAKE_ARGUMENTS
###     #     -DLUE_ENABLE_CPPCHECK:BOOL=FALSE
###     #     -DLUE_ENABLE_CLANG_TIDY:BOOL=FALSE
###     # "
###
### elif [[ $MY_DEVENV_BUILD_TYPE == "RelWithDebInfo" ]];
### then
###     LUE_CMAKE_ARGUMENTS="
###         $LUE_CMAKE_ARGUMENTS
###         -DLUE_BUILD_OTF2:BOOL=TRUE
###     "
### fi

### unset repository_cache cmake_toolchain_file

# export LUE_CMAKE_ARGUMENTS
# export CMAKE_BUILD_PARALLEL_LEVEL
# export LD_LIBRARY_PATH
# export LUE_OBJECTS LUE_DATA LUE_HOSTNAME LUE_ROUTING_DATA LUE_BENCHMARK_DATA
# export LUE_OBJECTS
export PATH
# export PYTHONPATH

cd $LUE

if [[ -n $(type -t lue) ]]; then
    unalias lue
fi
