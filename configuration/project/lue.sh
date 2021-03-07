cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

# TODO Turn into CMake settings (toolchains?), if necessary
# export MAKEFLAGS="$MAKEFLAGS --quiet"
# export CTEST_OUTPUT_ON_FAILURE=1

parse_commandline $*


if [ ! "$LUE" ]; then
    export LUE="$PROJECTS/`\ls $PROJECTS | \grep -i \"^lue$\"`"
fi


basename=`basename $LUE`

LUE_OBJECTS="$OBJECTS/$MY_DEVENV_BUILD_TYPE/$basename"
LUE_DATA="$OBJECTS/../data/$MY_DEVENV_BUILD_TYPE/$basename"

PATH="\
$LUE/environment/script:\
$PATH"

hostname=`hostname -s`

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

unset cmake_toolchain_file

if [[ $hostname == "gransasso" ]];
then
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

elif [[ $hostname == "login01" ]];
then
    LUE_CMAKE_ARGUMENTS="
        $LUE_CMAKE_ARGUMENTS
        -DBOOST_ROOT:PATH=/quanta1/home/jong0137/miniconda3/envs/lue
        -DGDAL_ROOT:PATH=/quanta1/home/jong0137/miniconda3/envs/lue
        -DHDF5_ROOT:PATH=/quanta1/home/jong0137/miniconda3/envs/lue
        -DLUE_BUILD_FRAMEWORK:BOOL=TRUE
        -DLUE_BUILD_DOCUMENTATION:BOOL=TRUE
        -DLUE_DATA_MODEL_WITH_PYTHON_API:BOOL=TRUE
        -DLUE_FRAMEWORK_WITH_BENCHMARKS:BOOL=TRUE
        -DLUE_FRAMEWORK_WITH_PYTHON_API:BOOL=TRUE
        -DLUE_TEST_NR_LOCALITIES_PER_TEST=2
        -DLUE_TEST_NR_THREADS_PER_LOCALITY=3
        -DLUE_TEST_HPX_RUNWRAPPER=mpi
        -DLUE_TEST_HPX_PARCELPORT=mpi
    "
    CMAKE_BUILD_PARALLEL_LEVEL=10
    PYTHONPATH=$LUE_OBJECTS/lib:$PYTHONPATH

elif [[ $hostname == "snowdon" ]];
then
    LUE_CMAKE_ARGUMENTS="
        $LUE_CMAKE_ARGUMENTS
        -DLUE_BUILD_FRAMEWORK:BOOL=TRUE
        -DLUE_FRAMEWORK_WITH_BENCHMARKS:BOOL=TRUE
        -DLUE_FRAMEWORK_WITH_PYTHON_API:BOOL=TRUE
        -DLUE_TEST_NR_LOCALITIES_PER_TEST=2
        -DLUE_TEST_NR_THREADS_PER_LOCALITY=2
    "
    CMAKE_BUILD_PARALLEL_LEVEL=4
    PYTHONPATH=$LUE_OBJECTS/lib:$PYTHONPATH

elif [[ $hostname == "sonic" ]];
then
    # TODO Move BOOST_ROOT into CMake toolchain file for sonic
    LUE_CMAKE_ARGUMENTS="
        $LUE_CMAKE_ARGUMENTS
        -DBOOST_INCLUDEDIR:PATH=/usr/include/boost169/
        -DBOOST_LIBRARYDIR:PATH=/usr/lib64/boost169/
        -DLUE_BUILD_FRAMEWORK:BOOL=TRUE
        -DLUE_FRAMEWORK_WITH_BENCHMARKS:BOOL=TRUE
        -DLUE_FRAMEWORK_WITH_PYTHON_API:BOOL=TRUE
        -DLUE_TEST_NR_LOCALITIES_PER_TEST=1
        -DLUE_TEST_NR_THREADS_PER_LOCALITY=4
        -DLUE_BUILD_DOCOPT:BOOL=TRUE
    "
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


export LUE_CMAKE_ARGUMENTS
export CMAKE_BUILD_PARALLEL_LEVEL
export LD_LIBRARY_PATH
export LUE_OBJECTS LUE_DATA
export PATH
export PYTHONPATH

cd $LUE

if [[ -n `type -t lue` ]]; then
    unalias lue
fi

conda activate lue

unset hostname

pwd
