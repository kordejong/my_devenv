cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*


if [ ! "$PCRASTER_HPX" ]; then
    export PCRASTER_HPX="$PROJECTS/`\ls $PROJECTS | \grep -i \"^pcraster_hpx$\"`"
fi


PCRASTER_HPX_CMAKE_ARGUMENTS="
    -DPEACOCK_PREFIX:PATH=$PEACOCK_PREFIX/pcraster_hpx
"
export PCRASTER_HPX_CMAKE_ARGUMENTS


basename=`basename $PCRASTER_HPX`

PATH="\
$PCRASTER_HPX/environment/script:\
$PATH"

unset basename


PYTHONPATH=$PCRASTER_HPX/devbase/source:$PYTHONPATH


export PATH
export PYTHONPATH

cd $PCRASTER_HPX

unalias pcraster_hpx 2>/dev/null

# Assumes this has been executed: mkvirtualenv pcraster_hpx
# mkvirtualenv --python python3.5 --system-site-packages pcraster_hpx
workon pcraster_hpx

pwd
