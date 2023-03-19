cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*

if [ ! "$INVEST" ]; then
    export INVEST="$PROJECTS/gauja/kordejong/invest"
fi

if [ ! -d "$INVEST" ]; then
    echo "ERROR: directory $INVEST does not exist..."
    return 1
fi

basename=`basename $INVEST`

PATH="$INVEST/source/script:$PATH"
PYTHONPATH="$INVEST/source/package:$PYTHONPATH"

unset basename

export PATH PYTHONPATH

cd $INVEST

unalias invest 2>/dev/null

hostname=`hostname -s`

source $INVEST/env/bin/activate

unset hostname

pwd
