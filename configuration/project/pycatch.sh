cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*


if [ ! "$PYCATCH" ]; then
    export PYCATCH="$PROJECTS/github/kordejong/pycatch"
fi

if [ ! -d "$PYCATCH" ]; then
    echo "ERROR: directory $PYCATCH does not exist..."
    return 1
fi

cd $PYCATCH

if [[ -n `type -t pycatch` ]]; then
    unalias pycatch
fi

source $PYCATCH/env/bin/activate
