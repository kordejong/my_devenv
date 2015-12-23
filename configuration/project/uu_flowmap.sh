cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd


parse_commandline $*


if [ ! "$UU_FLOWMAP" ]; then
    export UU_FLOWMAP="$PROJECTS/`\ls $PROJECTS | \grep -i \"^uu_flowmap$\"`"
fi

export PATH="$UU_FLOWMAP/environment/script:$PATH"

# UU_FLOWMAP_CMAKE_ARGUMENTS="
#     -DPEACOCK_PREFIX:PATH=$PEACOCK_PREFIX/uu_flowmap
# "
# if [[ $OSTYPE == "cygwin" ]]; then
#     UU_FLOWMAP_CMAKE_ARGUMENTS="
#         $UU_FLOWMAP_CMAKE_ARGUMENTS
#         -DCMAKE_MAKE_PROGRAM:STRING=mingw32-make
#     "
# fi
# 
# export UU_FLOWMAP_CMAKE_ARGUMENTS

set_prompt_for_project uu_flowmap $MY_DEVENV_BUILD_TYPE

cd $UU_FLOWMAP
