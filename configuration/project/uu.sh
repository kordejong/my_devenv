cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*


if [ ! "$UU" ]; then
    export UU="$PROJECTS/gauja/uu/uu"
fi


basename=`basename $UU`

UU_OBJECTS="$OBJECTS/$MY_DEVENV_BUILD_TYPE/$basename"
TEXINPUTS=".:$UU/presentation/tex:"

unset basename

export UU_OBJECTS
export TEXINPUTS

cd $UU

unalias phd 2>/dev/null

hostname=`hostname -s`

conda activate uu

unset hostname

pwd
