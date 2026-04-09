cwd=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "$cwd"/util.sh
unset cwd

parse_commandline "$*"

if [ ! "$BOSWALSTRO" ]; then
    export BOSWALSTRO="$PROJECTS/codeberg/kordejong/boswalstro"
fi

if [ ! -d "$BOSWALSTRO" ]; then
    echo "ERROR: directory $BOSWALSTRO does not exist..."
    return 1
fi

cd "$BOSWALSTRO" || exit

# linux-gnu, darwin, cygwin, win32, freebsd
if [[ "$OSTYPE" == "msys" ]]; then
    source .venv/Scripts/activate
else
    source .venv/bin/activate
fi

export PYTHONPATH="$BOSWALSTRO/source/package:$PYTHONPATH"

if [[ -n $(type -t boswalstro) ]]; then
    unalias boswalstro
fi
