cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*


if [ ! "$RUMINATIONS" ]; then
    export RUMINATIONS="$PROJECTS/github/kordejong/ruminations"
fi

if [ ! -d "$RUMINATIONS" ]; then
    echo "ERROR: directory $RUMINATIONS does not exist..."
    return 1
fi

basename=`basename $RUMINATIONS`

RUMINATIONS_OBJECTS="$OBJECTS/$basename"

unset basename

source $RUMINATIONS/env/bin/activate

cd $RUMINATIONS

if [[ -n `type -t ruminations` ]]; then
    unalias ruminations
fi
