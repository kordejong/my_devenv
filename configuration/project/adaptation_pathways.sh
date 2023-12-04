cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd


parse_commandline $*


if [ ! "$ADAPTATION_PATHWAYS" ]; then
    export ADAPTATION_PATHWAYS="$PROJECTS/gauja/geoneric/project/adaptation_pathways"
fi

if [ ! -d "$ADAPTATION_PATHWAYS" ]; then
    echo "ERROR: directory $ADAPTATION_PATHWAYS does not exist..."
    return 1
fi

export ADAPTATION_PATHWAYS_OBJECTS="$OBJECTS/adaptation_pathways"

PATH="$ADAPTATION_PATHWAYS/source/script:$PATH"

cd $ADAPTATION_PATHWAYS

source env/bin/activate

if [[ -n `type -t lue` ]]; then
    unalias adaptation_pathways
fi
