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

unset basename


hostname=`hostname -s`


LUE_CMAKE_ARGUMENTS="
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
    -DPEACOCK_PREFIX:PATH=$PEACOCK_PREFIX/lue
    -DLUE_BUILD_DATA_MODEL:BOOL=TRUE
    -DLUE_DATA_MODEL_WITH_PYTHON_API:BOOL=TRUE
    -DLUE_DATA_MODEL_WITH_UTILITIES:BOOL=TRUE
    -DLUE_BUILD_TEST:BOOL=TRUE
    -DLUE_BUILD_DOCUMENTATION:BOOL=TRUE
    -DCMAKE_TOOLCHAIN_FILE=$MY_DEVENV/configuration/platform/$hostname.cmake
"

if [[ $hostname == "gransasso" ]]; then
    LUE_CMAKE_ARGUMENTS="
        $LUE_CMAKE_ARGUMENTS
        -DLUE_BUILD_HPX=TRUE
        -DPYBIND11_PYTHON_VERSION=2.7
        -DLUE_BUILD_FRAMEWORK:BOOL=TRUE
        -DLUE_FRAMEWORK_WITH_OPENCL:BOOL=TRUE
        -DLUE_FRAMEWORK_WITH_DASHBOARD:BOOL=TRUE
        -DLUE_FRAMEWORK_WITH_BENCHMARKS:BOOL=TRUE
    "

    pcraster_prefix=/opt/pcraster-4.3-dev/usr/local
    PATH=$pcraster_prefix/bin:$PATH
    LD_LIBRARY_PATH=$pcraster_prefix/lib:$LD_LIBRARY_PATH
    PYTHONPATH=$LUE_OBJECTS/lib:$pcraster_prefix/python:$PYTHONPATH
    unset pcraster_prefix
fi

if [[ $hostname == "triklav" ]]; then
    # TODO Conflict between toolchain file and docopt CMake stuff
    LUE_CMAKE_ARGUMENTS="
        $LUE_CMAKE_ARGUMENTS
        -DLUE_DATA_MODEL_WITH_UTILITIES:BOOL=FALSE
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

unalias lue 2>/dev/null

# if [[ $hostname != "gransasso" ]]; then
    conda activate lue
# fi

unset hostname

pwd
