cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd


parse_commandline $*


if [ ! "$ATLAS" ]; then
    export ATLAS="$PROJECTS/`\ls $PROJECTS | \grep -i \"^atlas$\"`"
fi

export PATH="$ATLAS/environment/script:$PATH"

set_prompt_for_project rivm_atlas $MY_DEVENV_BUILD_TYPE

cd $ATLAS
