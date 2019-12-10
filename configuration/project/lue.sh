cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*


if [ ! "$LUE" ]; then
    export LUE="$PROJECTS/`\ls $PROJECTS | \grep -i \"^lue$\"`"
fi


basename=`basename $LUE`

LUE_OBJECTS="$OBJECTS/$MY_DEVENV_BUILD_TYPE/$basename"
PATH="\
$LUE/environment/script:\
$PATH"

hostname=`hostname -s`

LUE_CMAKE_ARGUMENTS="
    -DCMAKE_RULE_MESSAGES=OFF
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
    -DCMAKE_INSTALL_PREFIX:PATH=${TMPDIR:-/tmp}/$MY_DEVENV_BUILD_TYPE/$basename
    -DLUE_BUILD_DATA_MODEL:BOOL=TRUE
    -DLUE_DATA_MODEL_WITH_PYTHON_API:BOOL=TRUE
    -DLUE_DATA_MODEL_WITH_UTILITIES:BOOL=TRUE
    -DLUE_BUILD_TEST:BOOL=TRUE
    -DLUE_BUILD_DOCUMENTATION:BOOL=TRUE
    -DLUE_BUILD_HPX:BOOL=TRUE
    -DLUE_BUILD_OTF2:BOOL=TRUE
    -DPEACOCK_PREFIX:PATH=$PEACOCK_PREFIX/lue
"

unset basename

repository_cache="$HOME/development/repository"
if [ -d "$repository_cache" ]; then
    if [ -d "$repository_cache" ]; then
        LUE_CMAKE_ARGUMENTS="
            $LUE_CMAKE_ARGUMENTS
            -DLUE_REPOSITORY_CACHE:PATH=$repository_cache
        "
    fi
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


if [[ $hostname == "gransasso" || $hostname == "sonic" || $hostname == "snowdon" ]]; then
    # TODO Move PYBIND11_PYTHON_VERSION into CMake toolchain file for
    #     gransasso and sonic and snowdon
    LUE_CMAKE_ARGUMENTS="
        $LUE_CMAKE_ARGUMENTS
        -DPYBIND11_PYTHON_VERSION=2.7
        -DLUE_BUILD_FRAMEWORK:BOOL=TRUE
        -DLUE_FRAMEWORK_WITH_OPENCL:BOOL=FALSE
        -DLUE_FRAMEWORK_WITH_DASHBOARD:BOOL=TRUE
        -DLUE_FRAMEWORK_WITH_BENCHMARKS:BOOL=TRUE
    "

    if [[ $hostname == "gransasso" || $hostname == "snowdon" ]]; then
        PYTHONPATH=$LUE_OBJECTS/lib:$PYTHONPATH
    fi

    if [[ $hostname == "gransasso" ]]; then
        pcraster_prefix=/opt/pcraster-4.3-dev/usr/local

        PATH=$pcraster_prefix/bin:$PATH
        LD_LIBRARY_PATH=$pcraster_prefix/lib:$LD_LIBRARY_PATH
        PYTHONPATH=$pcraster_prefix/python:$PYTHONPATH
        unset pcraster_prefix
    fi

    if [[ $hostname == "sonic" ]]; then
        # TODO Move BOOST_ROOT into CMake toolchain file for sonic
        LUE_CMAKE_ARGUMENTS="
            $LUE_CMAKE_ARGUMENTS
            -DLUE_BUILD_DOCOPT:BOOL=TRUE
            -DBOOST_INCLUDEDIR:PATH=/usr/include/boost169/
            -DBOOST_LIBRARYDIR:PATH=/usr/lib64/boost169/
            -DLUE_FRAMEWORK_WITH_OPENCL:BOOL=FALSE
        "
    fi
fi

if [[ $hostname == "triklav" ]]; then
    # TODO Conflict between toolchain file and docopt CMake stuff
    # TODO Move PYBIND11_PYTHON_VERSION into CMake toolchain file for triklav
    LUE_CMAKE_ARGUMENTS="
        $LUE_CMAKE_ARGUMENTS
        -DPYBIND11_PYTHON_VERSION=3.6
        -DLUE_BUILD_DOCOPT:BOOL=TRUE
        -DLUE_DATA_MODEL_WITH_UTILITIES:BOOL=TRUE
        -DLUE_BUILD_FRAMEWORK:BOOL=FALSE
        -DLUE_FRAMEWORK_WITH_DASHBOARD:BOOL=FALSE
        -DLUE_FRAMEWORK_WITH_BENCHMARKS:BOOL=FALSE
    "
    PYTHONPATH=$LUE_OBJECTS/lib:$PYTHONPATH
fi

if [[ $hostname == "login01" ]]; then
    LUE_CMAKE_ARGUMENTS="
        $LUE_CMAKE_ARGUMENTS
        -DLUE_BUILD_FRAMEWORK:BOOL=TRUE
        -DLUE_BUILD_DOCUMENTATION:BOOL=TRUE
        -DLUE_DATA_MODEL_WITH_PYTHON_API:BOOL=TRUE
        -DLUE_FRAMEWORK_WITH_BENCHMARKS:BOOL=TRUE
    "
    PYTHONPATH=$LUE_OBJECTS/lib:$PYTHONPATH
fi


export LUE_CMAKE_ARGUMENTS


PYTHONPATH=$LUE/devbase/source:$PYTHONPATH

export LUE_CMAKE_ARGUMENTS
export LD_LIBRARY_PATH
export LUE_OBJECTS
export PATH
export PYTHONPATH

cd $LUE

if [[ -n `type -t lue` ]]; then
    unalias lue
fi

if [[ $hostname != "login01" ]]; then

    if [[ $hostname == "sonic" ]]; then
        workon lue
    else
        conda activate lue
    fi
fi

unset hostname

pwd
