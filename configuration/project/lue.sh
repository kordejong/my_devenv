cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*


if [ ! "$LUE" ]; then
    export LUE="$PROJECTS/`\ls $PROJECTS | \grep -i \"^lue$\"`"
fi


hostname=`hostname -s`


LUE_CMAKE_ARGUMENTS="
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
    -DPEACOCK_PREFIX:PATH=$PEACOCK_PREFIX/lue
    -DLUE_BUILD_PYTHON_API:BOOL=TRUE
    -DLUE_BUILD_TEST:BOOL=TRUE
    -DLUE_BUILD_DOCUMENTATION:BOOL=TRUE
    -DCMAKE_TOOLCHAIN_FILE=$MY_DEVENV/configuration/platform/$hostname.cmake
"

if [[ $hostname == "gransasso" ]]; then
    LUE_CMAKE_ARGUMENTS="
        $LUE_CMAKE_ARGUMENTS
        -DPYBIND11_PYTHON_VERSION=2.7
        -DLUE_BUILD_ALGORITHM:BOOL=TRUE
    "

    pcraster_prefix=/opt/pcraster-4.3-dev/usr/local
    PATH=$pcraster_prefix/bin:$PATH
    LD_LIBRARY_PATH=$pcraster_prefix/lib:$LD_LIBRARY_PATH
    PYTHONPATH=$pcraster_prefix/python:$PYTHONPATH
    unset pcraster_prefix
fi

if [[ $hostname == "triklav" ]]; then
    LUE_CMAKE_ARGUMENTS="
        $LUE_CMAKE_ARGUMENTS
        # TODO Conflict between toolchain file and docopt CMake stuff
        -DLUE_BUILD_UTILITIES:BOOL=FALSE
    "
fi

export LUE_CMAKE_ARGUMENTS


basename=`basename $LUE`

LUE_OBJECTS="$OBJECTS/$MY_DEVENV_BUILD_TYPE/$basename"
PATH="\
$LUE/environment/script:\
$PATH"

unset basename


PYTHONPATH=$LUE/devbase/source:$PYTHONPATH

export LUE_CMAKE_ARGUMENTS
export LD_LIBRARY_PATH
export LUE_OBJECTS
export PATH
export PYTHONPATH

cd $LUE

unalias lue 2>/dev/null

if [[ $hostname != "gransasso" ]]; then
    conda activate lue
fi

unset hostname

pwd
