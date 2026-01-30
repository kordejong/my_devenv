cwd=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*

COMPUTATIONALGEOGRAPHY_WEB="$PROJECTS/github/kordejong/computationalgeography-web"

if [ ! -d "$COMPUTATIONALGEOGRAPHY_WEB" ]; then
    echo "ERROR: directory $COMPUTATIONALGEOGRAPHY_WEB does not exist..."
    return 1
fi

export COMPUTATIONALGEOGRAPHY_WEB

cd $COMPUTATIONALGEOGRAPHY_WEB
source .venv/bin/activate
