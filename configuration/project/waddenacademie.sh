cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd


parse_commandline $*


if [ ! "$WADDENACADEMIE" ]; then
    export WADDENACADEMIE="$PROJECTS/`\ls $PROJECTS | \grep -i \"^waddenacademie$\"`"
fi

export PATH="$WADDENACADEMIE/environment/script:$PATH"

set_prompt_for_project waddenacademie $MY_DEVENV_BUILD_TYPE

cd $WADDENACADEMIE
