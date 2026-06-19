cwd=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline "$*"

if [ ! "$NATUUR_NAVIGATOR" ]; then
    export NATUUR_NAVIGATOR="$PROJECTS/codeberg/kordejong/documentation"
fi

if [ ! -d "$NATUUR_NAVIGATOR" ]; then
    echo "ERROR: directory $NATUUR_NAVIGATOR does not exist..."
    return 1
fi

cd $NATUUR_NAVIGATOR

# linux-gnu, darwin, cygwin, win32, freebsd
if [[ "$OSTYPE" == "msys" ]]; then
    source .venv/Scripts/activate
else
    source .venv/bin/activate
fi

if [[ -n $(type -t natuur_navigator) ]]; then
    unalias natuur_navigator
fi
