cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd


parse_commandline $*


if [ ! "$RIVM_ATLAS" ]; then
    export RIVM_ATLAS="$PROJECTS/`\ls $PROJECTS | \grep -i \"^rivm_atlas$\"`"
fi

# export PATH="$RIVM_ATLAS/environment/script:$PATH"

# RIVM_ATLAS_CMAKE_ARGUMENTS="
#     -DPEACOCK_PREFIX:PATH=$PEACOCK_PREFIX/rivm_atlas
# "
# if [[ $OSTYPE == "cygwin" ]]; then
#     RIVM_ATLAS_CMAKE_ARGUMENTS="
#         $RIVM_ATLAS_CMAKE_ARGUMENTS
#         -DCMAKE_MAKE_PROGRAM:STRING=mingw32-make
#     "
# fi
# 
# export RIVM_ATLAS_CMAKE_ARGUMENTS

set_prompt_for_project rivm_atlas $MY_DEVENV_BUILD_TYPE

cd $RIVM_ATLAS
