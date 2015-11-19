cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd


parse_commandline $*


if [ ! "$MAPS4SOCIETY" ]; then
    export MAPS4SOCIETY="$PROJECTS/`\ls $PROJECTS | \grep -i \"^maps4society$\"`"
fi

export PATH="$MAPS4SOCIETY/environment/script:$PATH"

MAPS4SOCIETY_CMAKE_ARGUMENTS="
    -DPEACOCK_PREFIX:PATH=$PEACOCK_PREFIX/maps4society
"
if [[ $OSTYPE == "cygwin" ]]; then
    MAPS4SOCIETY_CMAKE_ARGUMENTS="
        $MAPS4SOCIETY_CMAKE_ARGUMENTS
        -DCMAKE_MAKE_PROGRAM:STRING=mingw32-make
    "
fi

export MAPS4SOCIETY_CMAKE_ARGUMENTS

set_prompt_for_project maps4society $MY_DEVENV_BUILD_TYPE

cd $MAPS4SOCIETY
