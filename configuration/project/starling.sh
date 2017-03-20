cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*


if [ ! "$STARLING" ]; then
    export STARLING="$PROJECTS/`\ls $PROJECTS | \grep -i \"^starling$\"`"
fi


# This confuses the generate_python_package script.
# PYTHONPATH="$STARLING/source:$PYTHONPATH"

export PYTHONPATH

cd $STARLING

unalias starling 2>/dev/null

# mkvirtualenv --python /usr/bin/python3 --system-site-packages starling
# sonic: PATH=/opt/python-3/bin:$PATH mkvirtualenv --python /opt/python-3/bin/python3 --system-site-packages starling
workon starling

pwd
