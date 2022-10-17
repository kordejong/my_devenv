cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*

export LUE_WEB="$PROJECTS/github/computational_geography/lue-web"

if [ ! -d "$LUE_WEB" ]; then
    echo "ERROR: directory $LUE_WEB does not exist..."
    return 1
fi

export LUE_WEB

cd $LUE_WEB
source env/bin/activate
