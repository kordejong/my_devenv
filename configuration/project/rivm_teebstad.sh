cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd


parse_commandline $*


if [ ! "$RIVM_TEEBSTAD" ]; then
    export RIVM_TEEBSTAD="$PROJECTS/`\ls $PROJECTS | \grep -i \"^teebstad$\"`"
fi


cd $RIVM_TEEBSTAD
