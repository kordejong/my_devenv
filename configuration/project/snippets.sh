cwd=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "$cwd/util.sh"
unset cwd

parse_commandline $*

SNIPPETS="$PROJECTS/codeberg/kordejong/snippets"

if [ ! -d "$SNIPPETS" ]; then
    echo "ERROR: directory $SNIPPETS does not exist..."
    return 1
fi

basename=$(basename "$SNIPPETS")

SNIPPETS_OBJECTS="$OBJECTS/$MY_DEVENV_BUILD_TYPE/$basename"

unset basename

export SNIPPETS SNIPPETS_OBJECTS

unalias snippets 2>/dev/null

cd $SNIPPETS
source .venv/bin/activate
pwd
