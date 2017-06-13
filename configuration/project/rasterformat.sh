cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*


if [ ! "$RASTERFORMAT" ]; then
    export RASTERFORMAT="$PROJECTS/`\ls $PROJECTS | \grep -i \"^rasterformat$\"`"
fi

workon python

cd $RASTERFORMAT

unalias rasterformat 2>/dev/null

pwd
