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

SNIPPETS_HOSTNAME=$(hostname -s 2>/dev/null)

if [ ! "$SNIPPETS_HOSTNAME" ]; then
    SNIPPETS_HOSTNAME=$(hostname)
fi

if [ ! "$SNIPPETS_HOSTNAME" ]; then
    echo "Could not figure out the hostname"
    exit 1
fi

SNIPPETS_HOSTNAME="${SNIPPETS_HOSTNAME,,}" # Lower-case the hostname

if [[ $SNIPPETS_HOSTNAME == int? || $SNIPPETS_HOSTNAME == tcn* ]]; then
    SNIPPETS_HOSTNAME="snellius"
elif [[ $SNIPPETS_HOSTNAME == jr* ]]; then
    SNIPPETS_HOSTNAME="jureca"
elif [[ $SNIPPETS_HOSTNAME == wn-dc-05 ]]; then
    SNIPPETS_HOSTNAME="spider"
elif [[ $SNIPPETS_HOSTNAME == uu107273 || $SNIPPETS_HOSTNAME == uu-c07hg08bq6p0 ]]; then
    SNIPPETS_HOSTNAME="m1compiler"
elif [[ $HOME == /eejit/* ]]; then
    SNIPPETS_HOSTNAME="eejit"
fi

if [[ $SNIPPETS_HOSTNAME == "hoy" ]]; then
    source .venv/Scripts/activate
else
    source .venv/bin/activate
fi

pwd
