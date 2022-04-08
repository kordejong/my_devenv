cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

# TODO Turn into CMake settings (toolchains?), if necessary
# export MAKEFLAGS="$MAKEFLAGS --quiet"
# export CTEST_OUTPUT_ON_FAILURE=1

parse_commandline $*


if [ ! "$LUE" ]; then
    export LUE="$PROJECTS/computational_geography/lue"
fi

if [ ! -d "$LUE" ]; then
    echo "ERROR: directory $LUE does not exist..."
    return 1
fi

basename=`basename $LUE`

LUE_OBJECTS="$OBJECTS/$MY_DEVENV_BUILD_TYPE/$basename"
LUE_DATA="$OBJECTS/../data/$MY_DEVENV_BUILD_TYPE/$basename"

PATH="\
$LUE/environment/script:\
$PATH"

hostname=`hostname -s 2>/dev/null`

if [ ! "$hostname" ];
then
    hostname=`hostname`
fi

if [ ! "$hostname" ];
then
    echo "Could not figure out the hostname"
    exit 1
fi

hostname="${hostname,,}"  # Lower-case the hostname
echo $hostname


#   -DCMAKE_RULE_MESSAGES=OFF
LUE_CMAKE_ARGUMENTS="
    -DCMAKE_INSTALL_PREFIX:PATH=${TMPDIR:-/tmp}/$MY_DEVENV_BUILD_TYPE/$basename
    -DLUE_PYTHON_API_INSTALL_DIR:PATH=${TMPDIR:-/tmp}/$MY_DEVENV_BUILD_TYPE/$basename/python
    -DLUE_BUILD_DATA_MODEL:BOOL=TRUE
    -DLUE_DATA_MODEL_WITH_PYTHON_API:BOOL=TRUE
    -DLUE_DATA_MODEL_WITH_UTILITIES:BOOL=TRUE
    -DLUE_BUILD_VIEW:BOOL=TRUE
    -DLUE_BUILD_TEST:BOOL=TRUE
    -DLUE_BUILD_DOCUMENTATION:BOOL=TRUE
    -DLUE_BUILD_HPX:BOOL=TRUE
"

unset basename

repository_cache="$HOME/development/repository"
if [ -d "$repository_cache" ]; then
    LUE_CMAKE_ARGUMENTS="
        $LUE_CMAKE_ARGUMENTS
        -DLUE_REPOSITORY_CACHE:PATH=$repository_cache
    "
fi


cmake_toolchain_file=$MY_DEVENV/configuration/platform/cmake/$hostname/$MY_DEVENV_BUILD_TYPE.cmake

if [ ! -f $cmake_toolchain_file ]; then
    cmake_toolchain_file=$MY_DEVENV/configuration/platform/cmake/$hostname.cmake
fi

if [ ! -f $cmake_toolchain_file ]; then
    echo "INFO: No CMake toolchain file found for a $MY_DEVENV_BUILD_TYPE build on $hostname"
else
    LUE_CMAKE_ARGUMENTS="
        $LUE_CMAKE_ARGUMENTS
        -DCMAKE_TOOLCHAIN_FILE=$cmake_toolchain_file
    "
fi


if [[ $hostname == "gransasso" ]];
then
    # Platform for testing use of the Ubuntu packages of 3rd party
    # software LUE depends on. No LUE_HAVE_<NAME> variables set to FALSE.
    LUE_CMAKE_ARGUMENTS="
        $LUE_CMAKE_ARGUMENTS
        -DLUE_BUILD_FRAMEWORK:BOOL=TRUE
        -DLUE_FRAMEWORK_WITH_BENCHMARKS:BOOL=TRUE
        -DLUE_FRAMEWORK_WITH_PYTHON_API:BOOL=TRUE
        -DLUE_TEST_NR_LOCALITIES_PER_TEST=2
        -DLUE_TEST_NR_THREADS_PER_LOCALITY=2
    "
    CMAKE_BUILD_PARALLEL_LEVEL=5
    PYTHONPATH=$LUE_OBJECTS/lib:$PYTHONPATH
    LUE_ROUTING_DATA="/mnt/data1/home/kor/data/project/routing"
    LUE_BENCHMARK_DATA="/mnt/data1/home/kor/data/project/lue/benchmark/gransasso/"

elif [[ $hostname == "fg-vm12" ]];
then
    if [ -d "$repository_cache" ]; then
        LUE_CMAKE_ARGUMENTS="
            $LUE_CMAKE_ARGUMENTS
            -DLUE_REPOSITORY_CACHE:PATH=$(cygpath --mixed $repository_cache)
        "
    fi

    LUE_CMAKE_ARGUMENTS="
        $LUE_CMAKE_ARGUMENTS
        -DCMAKE_TOOLCHAIN_FILE=$(cygpath --mixed $cmake_toolchain_file)
    "

    LUE_CMAKE_ARGUMENTS="
        $LUE_CMAKE_ARGUMENTS
        -DLUE_DATA_MODEL_WITH_PYTHON_API:BOOL=TRUE
        -DLUE_DATA_MODEL_WITH_UTILITIES:BOOL=TRUE
        -DLUE_BUILD_DOCUMENTATION:BOOL=FALSE
        -DLUE_BUILD_FRAMEWORK:BOOL=TRUE
        -DLUE_FRAMEWORK_WITH_BENCHMARKS:BOOL=FALSE
        -DLUE_FRAMEWORK_WITH_PYTHON_API:BOOL=TRUE
        -DLUE_TEST_NR_LOCALITIES_PER_TEST=2
        -DLUE_TEST_NR_THREADS_PER_LOCALITY=1
        -DLUE_HAVE_BOOST:BOOL=TRUE
        -DLUE_HAVE_DOCOPT:BOOL=FALSE
        -DLUE_HAVE_FMT:BOOL=FALSE
        -DLUE_HAVE_GDAL:BOOL=TRUE
        -DLUE_HAVE_GLEW:BOOL=FALSE
        -DLUE_HAVE_GLFW:BOOL=FALSE
        -DLUE_HAVE_HDF5:BOOL=TRUE
        -DLUE_HAVE_NLOHMANN_JSON:BOOL=FALSE
        -DLUE_HAVE_PYBIND11:BOOL=FALSE
    "
    CMAKE_BUILD_PARALLEL_LEVEL=2
    # PATH=$LUE_OBJECTS/bin/$MY_DEVENV_BUILD_TYPE:$PATH
    # PYTHONPATH=$LUE_OBJECTS/lib/$MY_DEVENV_BUILD_TYPE:$PYTHONPATH
    LUE_ROUTING_DATA="$HOME/not_needed_on_windows_yet"

    ### # export PATH="`cygpath --mixed /C/Program\ Files\ \(x86\)/Microsoft\ Visual\ Studio/2019/Community/VC/Tools/MSVC/14.29.30133/bin/Hostx64/x64`:$PATH"
    ### export CC=C:/PROGRA~2/MICROS~1/2019/COMMUN~1/VC/Tools/MSVC/1429~1.301/bin/Hostx64/x64/cl
    ### export CXX=C:/PROGRA~2/MICROS~1/2019/COMMUN~1/VC/Tools/MSVC/1429~1.301/bin/Hostx64/x64/cl
    ### # export CC="$(cygpath --mixed /C/Program\ Files\ \(x86\)/Microsoft\ Visual\ Studio/2019/Community/VC/Tools/MSVC/14.29.30133/bin/Hostx64/x64/cl)"
    ### # export CXX="$(cygpath --mixed /C/Program\ Files\ \(x86\)/Microsoft\ Visual\ Studio/2019/Community/VC/Tools/MSVC/14.29.30133/bin/Hostx64/x64/cl)"

### elif [[ $hostname == "ketjen" ]];
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
###         -DLUE_FRAMEWORK_WITH_BENCHMARKS:BOOL=TRUE
###         -DLUE_FRAMEWORK_WITH_PYTHON_API:BOOL=TRUE
###         -DLUE_TEST_NR_LOCALITIES_PER_TEST=2
###         -DLUE_TEST_NR_THREADS_PER_LOCALITY=1
###         -DLUE_HAVE_BOOST:BOOL=FALSE
###         -DLUE_HAVE_DOCOPT:BOOL=FALSE
###         -DLUE_HAVE_FMT:BOOL=FALSE
###         -DLUE_HAVE_GDAL:BOOL=FALSE
###         -DLUE_HAVE_GLEW:BOOL=FALSE
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

elif [[ $hostname == "login01" ]];
then
    # Platform for production runs.
    LUE_CMAKE_ARGUMENTS="
        $LUE_CMAKE_ARGUMENTS
        -DCMAKE_INSTALL_PREFIX:PATH=/scratch/depfg/software/lue/yyyymmdd/$MY_DEVENV_BUILD_TYPE
        -DLUE_PYTHON_API_INSTALL_DIR:PATH=/scratch/depfg/software/lue/yyyymmdd/$MY_DEVENV_BUILD_TYPE/python
        -DLUE_BUILD_FRAMEWORK:BOOL=TRUE
        -DLUE_BUILD_VIEW:BOOL=FALSE
        -DLUE_BUILD_DOCUMENTATION:BOOL=FALSE
        -DLUE_DATA_MODEL_WITH_PYTHON_API:BOOL=TRUE
        -DLUE_FRAMEWORK_WITH_BENCHMARKS:BOOL=TRUE
        -DLUE_FRAMEWORK_WITH_PYTHON_API:BOOL=TRUE
        -DLUE_HAVE_DOCOPT:BOOL=FALSE
        -DLUE_HAVE_FMT:BOOL=FALSE
        -DLUE_HAVE_NLOHMANN_JSON:BOOL=FALSE
        -DLUE_HAVE_PYBIND11:BOOL=FALSE
        -DLUE_TEST_NR_LOCALITIES_PER_TEST=2
        -DLUE_TEST_NR_THREADS_PER_LOCALITY=3
        -DLUE_TEST_HPX_RUNWRAPPER=mpi
        -DLUE_TEST_HPX_PARCELPORT=mpi
    "
    CMAKE_BUILD_PARALLEL_LEVEL=10
    PYTHONPATH=$LUE_OBJECTS/lib:$PYTHONPATH
    LUE_ROUTING_DATA="/scratch/depfg/jong0137/data/routing"
    LUE_BENCHMARK_DATA="/scratch/depfg/jong0137/data/project/lue/benchmark"

elif [[ $hostname == "snowdon" ]];
then
    # Platform for testing use of the Conan packages of 3rd party software
    # LUE depends on. LUE_HAVE_<NAME> variables set to FALSE.
    LUE_CMAKE_ARGUMENTS="
        $LUE_CMAKE_ARGUMENTS
        -DLUE_BUILD_FRAMEWORK:BOOL=TRUE
        -DLUE_FRAMEWORK_WITH_BENCHMARKS:BOOL=TRUE
        -DLUE_FRAMEWORK_WITH_PYTHON_API:BOOL=TRUE
        -DLUE_TEST_NR_LOCALITIES_PER_TEST=2
        -DLUE_TEST_NR_THREADS_PER_LOCALITY=2
        -DLUE_HAVE_BOOST:BOOL=FALSE
        -DLUE_HAVE_DOCOPT:BOOL=FALSE
        -DLUE_HAVE_FMT:BOOL=FALSE
        -DLUE_HAVE_GDAL:BOOL=FALSE
        -DLUE_HAVE_GLEW:BOOL=FALSE
        -DLUE_HAVE_GLFW:BOOL=FALSE
        -DLUE_HAVE_HDF5:BOOL=FALSE
        -DLUE_HAVE_NETCDF4:BOOL=FALSE
        -DLUE_HAVE_NLOHMANN_JSON:BOOL=FALSE
        -DLUE_HAVE_PYBIND11:BOOL=FALSE
    "
    CMAKE_BUILD_PARALLEL_LEVEL=4
    PYTHONPATH=$LUE_OBJECTS/lib:$PYTHONPATH
    LUE_ROUTING_DATA="$HOME/development/data/project/routing"
fi


if [[ $MY_DEVENV_BUILD_TYPE == "Debug" ]];
then
    LUE_CMAKE_ARGUMENTS="
        $LUE_CMAKE_ARGUMENTS
        -DLUE_ASSERT_CONDITIONS:BOOL=TRUE
    "

    # LUE_CMAKE_ARGUMENTS="
    #     $LUE_CMAKE_ARGUMENTS
    #     -DLUE_ENABLE_CPPCHECK:BOOL=FALSE
    #     -DLUE_ENABLE_CLANG_TIDY:BOOL=FALSE
    # "

elif [[ $MY_DEVENV_BUILD_TYPE == "RelWithDebInfo" ]];
then
    LUE_CMAKE_ARGUMENTS="
        $LUE_CMAKE_ARGUMENTS
        -DLUE_BUILD_OTF2:BOOL=TRUE
    "
fi


unset repository_cache cmake_toolchain_file


export LUE_CMAKE_ARGUMENTS
export CMAKE_BUILD_PARALLEL_LEVEL
export LD_LIBRARY_PATH
export LUE_OBJECTS LUE_DATA LUE_ROUTING_DATA LUE_BENCHMARK_DATA
export PATH
export PYTHONPATH

cd $LUE

if [[ -n `type -t lue` ]]; then
    unalias lue
fi

conda activate lue

unset hostname

pwd
