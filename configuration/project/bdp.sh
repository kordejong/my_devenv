cwd=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*

if [ ! "$BDP" ]; then
    export BDP="$PROJECTS/gauja/geoneric/project/biodiversiteitplanner"
fi

if [ ! -d "$BDP" ]; then
    echo "ERROR: directory $BDP does not exist..."
    return 1
fi

cd $BDP

# linux-gnu, darwin, cygwin, win32, freebsd
if [[ "$OSTYPE" == "msys" ]]; then
    source .venv/Scripts/activate
else
    source .venv/bin/activate
fi

if [[ -n $(type -t bdp) ]]; then
    unalias bdp
fi
