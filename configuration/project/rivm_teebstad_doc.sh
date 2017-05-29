cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd


parse_commandline $*


if [ ! "$RIVM_TEEBSTAD_DOC" ]; then
    export RIVM_TEEBSTAD_DOC="$PROJECTS/`\ls $PROJECTS | \grep -i \"^teebstad-doc$\"`"
fi


cd $RIVM_TEEBSTAD_DOC
