cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*

if [ ! "$ADAPTATION_PATHWAYS" ]; then
    export ADAPTATION_PATHWAYS="$PROJECTS/github/geoneric/PathwaysGenerator"
fi

if [ ! -d "$ADAPTATION_PATHWAYS" ]; then
    echo "ERROR: directory $ADAPTATION_PATHWAYS does not exist..."
    return 1
fi

export ADAPTATION_PATHWAYS_OBJECTS="$OBJECTS/PathwaysGenerator"

cd $ADAPTATION_PATHWAYS

# linux-gnu, darwin, cygwin, win32, freebsd
if [[ "$OSTYPE" == "msys" ]];
then
    source env/Scripts/activate
else
    source env/bin/activate
fi

if [[ -n `type -t adaptation_pathways` ]]; then
    unalias adaptation_pathways
fi
