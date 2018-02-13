cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*


if [ ! "$PHD" ]; then
    export PHD="$PROJECTS/`\ls $PROJECTS | \grep -i \"^phd$\"`"
fi


# PHD_CMAKE_ARGUMENTS="
#     -DPEACOCK_PREFIX:PATH=$PEACOCK_PREFIX/phd
# "
# export PHD_CMAKE_ARGUMENTS


basename=`basename $PHD`

PHD_OBJECTS="$OBJECTS/$MY_DEVENV_BUILD_TYPE/$basename"
PATH="\
$PHD/environment/script:\
$PATH"

unset basename


export PHD_OBJECTS
export PATH

cd $PHD

unalias phd 2>/dev/null

pwd
