cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*

if [ ! "$TREKR" ]; then
    export TREKR="$PROJECTS/github/kordejong/trekr"
fi

if [ ! -d "$TREKR" ]; then
    echo "ERROR: directory $TREKR does not exist..."
    return 1
fi

export TREKR_OBJECTS="$OBJECTS/trekr"

cd $TREKR

source env/bin/activate

if [[ -n `type -t trekr` ]]; then
    unalias trekr
fi
