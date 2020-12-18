cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*

export SNIPPETS="$PROJECTS/gauja/kordejong/snippets"

basename=`basename $SNIPPETS`

SNIPPETS_OBJECTS="$OBJECTS/$MY_DEVENV_BUILD_TYPE/$basename"

unset basename

export SNIPPETS_OBJECTS

unalias snippets 2>/dev/null

cd $SNIPPETS
pwd
