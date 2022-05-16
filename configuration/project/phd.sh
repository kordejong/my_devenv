cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*

if [ ! "$PHD" ]; then
    export PHD="$PROJECTS/gauja/uu/project/phd"
fi

if [ ! -d "$PHD" ]; then
    echo "ERROR: directory $PHD does not exist..."
    return 1
fi

PHD_CMAKE_ARGUMENTS="
    -DCMAKE_INSTALL_PREFIX:PATH=${TMPDIR:-/tmp}/$MY_DEVENV_BUILD_TYPE/$basename
"
export PHD_CMAKE_ARGUMENTS


basename=`basename $PHD`

PHD_OBJECTS="$OBJECTS/$MY_DEVENV_BUILD_TYPE/$basename"
PATH="\
$PHD/environment/script:\
$PATH"

unset basename

PYTHONPATH="$PHD/source:$PYTHONPATH"
# TODO Remove $PHD_OBJECTS/figure in favor of $PHD_OBJECTS. Update
#     sources to include the 'figure' part.
TEXINPUTS=".:$PHD_OBJECTS:$PHD_OBJECTS/figure:$PHD/presentation/tex:"

export PHD_OBJECTS
export PATH
export PYTHONPATH
export TEXINPUTS

cd $PHD

unalias phd 2>/dev/null

hostname=`hostname -s`

conda activate phd

unset hostname

pwd
