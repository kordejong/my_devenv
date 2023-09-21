cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*

if [ ! "$NATURE_OF_CODE" ]; then
    export NATURE_OF_CODE="$PROJECTS/github/kordejong/nature_of_code"
fi

if [ ! -d "$NATURE_OF_CODE" ]; then
    echo "ERROR: directory $NATURE_OF_CODE does not exist..."
    return 1
fi

NATURE_OF_CODE_OBJECTS="$OBJECTS/$MY_DEVENV_BUILD_TYPE/$(basename $NATURE_OF_CODE)"

export PYTHONPATH=$NATURE_OF_CODE/source/python/package:$PYTHONPATH

source $NATURE_OF_CODE/env/bin/activate

cd $NATURE_OF_CODE
pwd
