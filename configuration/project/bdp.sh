cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd


parse_commandline $*


if [ ! "$BDP" ]; then
    export BDP="$PROJECTS/gauja/geoneric/project/biodiversiteitsplanner"
fi

if [ ! -d "$BDP" ]; then
    echo "ERROR: directory $BDP does not exist..."
    return 1
fi

export BDP_OBJECTS="$OBJECTS/biodiversiteitsplanner"

cd $BDP

# linux-gnu, darwin, cygwin, win32, freebsd
if [[ "$OSTYPE" == "msys" ]];
then
    source env/Scripts/activate
else
    source env/bin/activate
fi

if [[ -n `type -t bdp` ]]; then
    unalias bdp
fi
