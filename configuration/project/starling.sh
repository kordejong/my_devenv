cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*


if [ ! "$STARLING" ]; then
    export STARLING="$PROJECTS/`\ls $PROJECTS | \grep -i \"^starling$\"`"
fi


PYTHONPATH="$STARLING/source:$PYTHONPATH"

export PYTHONPATH

cd $STARLING

unalias starling 2>/dev/null

# Assumes this has been executed: mkvirtualenv starling
# gransasso:
#     mkvirtualenv --python /usr/bin/python3 --system-site-packages starling
workon starling

pwd
