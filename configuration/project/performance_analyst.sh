cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd


parse_commandline $*


if [ ! "$PERFORMANCE_ANALYST" ]; then
    export PERFORMANCE_ANALYST="$PROJECTS/`\ls $PROJECTS | \grep -i \"^performance_analyst$\"`"
fi

export PATH="$PERFORMANCE_ANALYST/environment/script:$PERFORMANCE_ANALYST/source/tool:$PATH"
export PYTHONPATH="$PERFORMANCE_ANALYST/source:$PYTHONPATH"


set_prompt_for_project performance_analyst $MY_DEVENV_BUILD_TYPE

cd $PERFORMANCE_ANALYST
