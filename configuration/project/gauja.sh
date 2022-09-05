cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*


if [ ! "$GAUJA" ]; then
    export GAUJA="$PROJECTS/gauja/kordejong/gauja"
fi

if [ ! -d "$GAUJA" ]; then
    echo "ERROR: directory $GAUJA does not exist..."
    return 1
fi

cd $GAUJA

if [[ -n `type -t gauja` ]]; then
    unalias gauja
fi
