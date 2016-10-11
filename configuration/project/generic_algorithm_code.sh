cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*


if [ ! "$GENERIC_ALGORITHM_CODE" ]; then
    export GENERIC_ALGORITHM_CODE="$PROJECTS/`\ls $PROJECTS | \grep -i \"^generic_algorithm_code$\"`"
fi


GENERIC_ALGORITHM_CODE_CMAKE_ARGUMENTS="
    -DPEACOCK_PREFIX:PATH=$PEACOCK_PREFIX/generic_algorithm_code
"
export GENERIC_ALGORITHM_CODE_CMAKE_ARGUMENTS


basename=`basename $GENERIC_ALGORITHM_CODE`
PYTHONPATH="$OBJECTS/$MY_DEVENV_BUILD_TYPE/$basename/bin:$PYTHONPATH"
unset basename

PYTHONPATH=$GENERIC_ALGORITHM_CODE/devbase/source:$PYTHONPATH

export PATH
export PYTHONPATH

cd $GENERIC_ALGORITHM_CODE

unalias generic_algorithm_code 2>/dev/null

workon generic_algorithm_code

pwd
