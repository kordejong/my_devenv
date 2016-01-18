cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd


parse_commandline $*


if [ ! "$QUICK_SCAN" ]; then
    export QUICK_SCAN="$PROJECTS/`\ls $PROJECTS | \grep -i \"^quick_scan$\"`"
fi

PATH=$QUICK_SCAN/environment/script:$PATH
PYTHONPATH=$QUICK_SCAN/source:$PYTHONPATH

alias psql_quick_scan="psql postgresql://$QUICK_SCAN_DATABASE_USER:$QUICK_SCAN_DATABASE_PASSWORD@$QUICK_SCAN_DATABASE_HOST/$QUICK_SCAN_DATABASE_NAME"

export PATH PYTHONPATH


set_prompt_for_project quick_scan $MY_DEVENV_BUILD_TYPE

cd $QUICK_SCAN
