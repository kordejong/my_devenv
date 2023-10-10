cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*

if [ ! "$LUE_CONSUME" ]; then
    export LUE_CONSUME="$PROJECTS/github/computational_geography/lue_consume"
fi

cd $LUE_CONSUME

unalias lue_consume 2>/dev/null
