cwd=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*

if [ ! "$GAME_OF_LIFE" ]; then
    export GAME_OF_LIFE="$PROJECTS/github/computational_geography/game_of_life"
fi

if [ ! -d "$GAME_OF_LIFE" ]; then
    echo "ERROR: directory $GAME_OF_LIFE does not exist..."
    return 1
fi

cd $GAME_OF_LIFE || exit

if [[ "$OSTYPE" == "msys" ]]; then
    source .venv/Scripts/activate
else
    source .venv/bin/activate
fi

if [[ -n $(type -t GAME_OF_LIFE) ]]; then
    unalias GAME_OF_LIFE
fi
