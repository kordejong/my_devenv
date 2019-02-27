cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*


if [ ! "$PHD" ]; then
    export PHD="$PROJECTS/`\ls $PROJECTS | \grep -i \"^phd$\"`"
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

export PHD_OBJECTS
export PATH
export PYTHONPATH

cd $PHD

unalias phd 2>/dev/null

hostname=`hostname -s`

if [[ $hostname == "sonic" ]]; then
    workon phd
else
    conda activate phd
fi

unset hostname

pwd
