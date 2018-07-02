cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*


if [ ! "$LUE" ]; then
    export LUE="$PROJECTS/`\ls $PROJECTS | \grep -i \"^lue$\"`"
fi


LUE_CMAKE_ARGUMENTS="
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
    -DPEACOCK_PREFIX:PATH=$PEACOCK_PREFIX/lue
    -DLUE_BUILD_PYTHON_API:BOOL=TRUE
    -DLUE_BUILD_UTILITIES:BOOL=TRUE
    -DLUE_BUILD_HL_API:BOOL=TRUE
    -DLUE_BUILD_CXX_API:BOOL=TRUE
    -DLUE_BUILD_TEST:BOOL=TRUE
    -DLUE_BUILD_DOCUMENTATION:BOOL=TRUE
"
export LUE_CMAKE_ARGUMENTS


basename=`basename $LUE`

LUE_OBJECTS="$OBJECTS/$MY_DEVENV_BUILD_TYPE/$basename"
PATH="\
$LUE/environment/script:\
$LUE_OBJECTS/source/lue_dump:\
$LUE_OBJECTS/source/lue_translate:\
$LUE_OBJECTS/source/lue_validate:\
$PATH"
# PYTHONPATH="$LUE_OBJECTS/source/lue_py:$PYTHONPATH"
PYTHONPATH="$LUE_OBJECTS/lib:$PYTHONPATH"

unset basename


PYTHONPATH=$LUE/devbase/source:$PYTHONPATH


export LUE_OBJECTS
export PATH
export PYTHONPATH

cd $LUE

unalias lue 2>/dev/null

# Assumes this has been executed: mkvirtualenv lue
# mkvirtualenv --python /usr/bin/python3 --system-site-packages lue
workon lue

pwd
