cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*

if [ ! "$UU" ]; then
    export UU="$PROJECTS/gauja/uu/uu"
fi

if [ ! -d "$UU" ]; then
    echo "ERROR: directory $UU does not exist..."
    return 1
fi

basename=`basename $UU`

PATH="$UU/environment/script:$PATH"
TEXINPUTS=".:$UU/presentation/tex:"

unset basename

export PATH
export TEXINPUTS

cd $UU

unalias phd 2>/dev/null

hostname=`hostname -s`

source env/bin/activate

unset hostname

pwd
