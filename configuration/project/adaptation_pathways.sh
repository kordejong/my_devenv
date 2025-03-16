cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*

if [ ! "$ADAPTATION_PATHWAYS" ]; then
    export ADAPTATION_PATHWAYS="$PROJECTS/github/Deltares-research/PathwaysGenerator"
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
    source .venv/Scripts/activate
else
    source .venv/bin/activate
fi

if [[ -n `type -t adaptation_pathways` ]]; then
    unalias adaptation_pathways
fi

export PATH="$ADAPTATION_PATHWAYS/environment/script:$ADAPTATION_PATHWAYS/source/script:$PATH"
export PYTHONPATH="$ADAPTATION_PATHWAYS/source/package:$PYTHONPATH"
