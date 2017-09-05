cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*


if [ ! "$PCRASTER_HPX" ]; then
    export PCRASTER_HPX="$PROJECTS/`\ls $PROJECTS | \grep -i \"^pcraster_hpx$\"`"
fi


# -DSUBPROJECT_HPX=ON
PCRASTER_HPX_CMAKE_ARGUMENTS="
    -DHPX_WITH_EXAMPLES:BOOL=OFF
    -DHPX_WITH_TESTS:BOOL=OFF
    -DHPX_WITH_MALLOC=JEMALLOC
    -DHPX_WITH_HWLOC:BOOL=ON
    -DHPX_WITH_THREAD_IDLE_RATES=ON
    -DHPX_DOWNLOAD_AS_SUBPROJECT=ON
    -DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=ON
    -DPEACOCK_PREFIX:PATH=$PEACOCK_PREFIX/pcraster_hpx
"

# On Cartesius:
# -DHPX_PARCELPORT_MPI:BOOL=ON


export PCRASTER_HPX_CMAKE_ARGUMENTS


basename=`basename $PCRASTER_HPX`

PATH="\
$PCRASTER_HPX/environment/script:\
$PATH"

unset basename


PYTHONPATH=$PCRASTER_HPX/devbase/source:$PYTHONPATH


export PATH
export PYTHONPATH

cd $PCRASTER_HPX/source/hpc_case/airpolution/hpx/airpolution

unalias pcraster_hpx 2>/dev/null

# Assumes this has been executed: mkvirtualenv pcraster_hpx
# mkvirtualenv --python python3.5 --system-site-packages pcraster_hpx
workon pcraster_hpx

pwd
