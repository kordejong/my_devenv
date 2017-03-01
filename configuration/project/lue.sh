cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*


if [ ! "$LUE" ]; then
    export LUE="$PROJECTS/`\ls $PROJECTS | \grep -i \"^lue$\"`"
fi


LUE_CMAKE_ARGUMENTS="
    -DLUE_BUILD_DOCUMENTATION:BOOL=TRUE
    -DLUE_BUILD_TEST:BOOL=TRUE
    -DLUE_BUILD_CXX_API:BOOL=TRUE
    -DLUE_BUILD_PYTHON_API:BOOL=TRUE
    -DLUE_BUILD_UTILITIES:BOOL=TRUE
    -DPEACOCK_PREFIX:PATH=$PEACOCK_PREFIX/lue
"
export LUE_CMAKE_ARGUMENTS


basename=`basename $LUE`

PATH="\
$LUE/environment/script:\
$OBJECTS/$MY_DEVENV_BUILD_TYPE/$basename/source/lue/utility/lue_dump:\
$OBJECTS/$MY_DEVENV_BUILD_TYPE/$basename/source/lue/utility/lue_translate:\
$OBJECTS/$MY_DEVENV_BUILD_TYPE/$basename/source/lue/utility/lue_validate:\
$PATH"

PYTHONPATH="$OBJECTS/$MY_DEVENV_BUILD_TYPE/$basename/source/luepy:$PYTHONPATH"


unset basename


PYTHONPATH=$LUE/devbase/source:$PYTHONPATH


export PATH
export PYTHONPATH

cd $LUE

unalias lue 2>/dev/null

# Assumes this has been executed: mkvirtualenv lue
# mkvirtualenv --python /usr/bin/python3 --system-site-packages lue
workon lue

pwd
