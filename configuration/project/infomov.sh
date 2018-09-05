cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*


if [ ! "$INFOMOV" ]; then
    export INFOMOV="$PROJECTS/`\ls $PROJECTS | \grep -i \"^infomov$\"`"
fi


INFOMOV_CMAKE_ARGUMENTS="
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
"
#   -DPEACOCK_PREFIX:PATH=$PEACOCK_PREFIX/infomov
export INFOMOV_CMAKE_ARGUMENTS


basename=`basename $INFOMOV`

INFOMOV_OBJECTS="$OBJECTS/$MY_DEVENV_BUILD_TYPE/$basename"

unset basename

export INFOMOV_OBJECTS

cd $INFOMOV

unalias infomov 2>/dev/null

conda activate infomov

pwd
