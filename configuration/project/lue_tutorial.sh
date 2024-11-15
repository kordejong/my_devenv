cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*

if [ ! "$LUE_TUTORIAL" ]; then
    export LUE_TUTORIAL="$PROJECTS/github/computational_geography/lue_tutorial"
fi

if [ ! -d "$LUE_TUTORIAL" ]; then
    echo "ERROR: directory $LUE_TUTORIAL does not exist..."
    return 1
fi

cd $LUE_TUTORIAL

unalias lue_tutorial 2>/dev/null

conda activate lue_tutorial
