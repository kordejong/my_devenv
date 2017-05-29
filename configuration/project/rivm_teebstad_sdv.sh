cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd


parse_commandline $*


if [ ! "$RIVM_TEEBSTAD_SDV" ]; then
    export RIVM_TEEBSTAD_SDV="$PROJECTS/`\ls $PROJECTS | \grep -i \"^teebstad-sdv$\"`"
fi


cd $RIVM_TEEBSTAD_SDV
