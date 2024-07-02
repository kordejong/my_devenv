cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*

PAPER_2024_LUE="$PROJECTS/github/computational_geography/paper_2024_lue"
PAPER_2024_LUE_OBJECTS="$OBJECTS/paper_2024_lue"

if [ ! -d "$PAPER_2024_LUE" ]; then
    echo "ERROR: directory $PAPER_2024_LUE does not exist..."
    return 1
fi

export PAPER_2024_LUE PAPER_2024_LUE_OBJECTS

cd $PAPER_2024_LUE

source env/bin/activate
