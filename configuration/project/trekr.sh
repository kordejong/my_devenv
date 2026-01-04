cwd=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*

if [ ! "$TREKR" ]; then
    export TREKR="$PROJECTS/codeberg/kordejong/trekr"
fi

if [ ! -d "$TREKR" ]; then
    echo "ERROR: directory $TREKR does not exist..."
    return 1
fi

cd $TREKR

source .venv/bin/activate

if [[ -n $(type -t trekr) ]]; then
    unalias trekr
fi
