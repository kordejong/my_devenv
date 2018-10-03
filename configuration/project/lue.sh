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
"

if [[ $hostname != "triklav" ]]; then
    LUE_CMAKE_ARGUMENTS="
        $LUE_CMAKE_ARGUMENTS
        -DCMAKE_TOOLCHAIN_FILE=$MY_DEVENV/configuration/platform/$hostname.cmake
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


export LUE_OBJECTS
export PATH
export PYTHONPATH

cd $LUE

unalias lue 2>/dev/null

conda activate lue

pwd
