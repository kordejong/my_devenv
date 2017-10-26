cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd


parse_commandline $*


if [ ! "$PCRASTER" ]; then
    export PCRASTER="$PROJECTS/`\ls $PROJECTS | \grep -i \"^pcraster$\"`"
fi


basename=`basename $PCRASTER`

PATH="$PCRASTER/environment/script:$PATH"
PYTHONPATH="$PCRASTER/devbase/source:$PYTHONPATH"


PCRASTER_CMAKE_ARGUMENTS="
    -DPEACOCK_PREFIX:PATH=$PEACOCK_PREFIX/pcraster
"
if [[ $OSTYPE == "cygwin" ]]; then
    PCRASTER_CMAKE_ARGUMENTS="
        $PCRASTER_CMAKE_ARGUMENTS
        -DCMAKE_MAKE_PROGRAM:STRING=mingw32-make
    "
fi


# -DPCRASTER_BUILD_ALL:BOOL=TRUE
# -DPCRASTER_WITH_ALL:BOOL=TRUE
PCRASTER_CMAKE_ARGUMENTS="
    $PCRASTER_CMAKE_ARGUMENTS
    -DPCRASTER_BUILD_DOCUMENTATION:BOOL=FALSE
    -DPCRASTER_BUILD_TEST:BOOL=TRUE
    -DPCRASTER_BUILD_BLOCKPYTHON=TRUE
    -DPCRASTER_WITH_PYTHON_MULTICORE=TRUE
"

PATH="$OBJECTS/$MY_DEVENV_BUILD_TYPE/$basename/bin:$PATH"
PYTHONPATH="$PCRASTER/source:$OBJECTS/$MY_DEVENV_BUILD_TYPE/$basename/bin:$PYTHONPATH"


if [[ $OSTYPE == "linux-gnu" ]]; then
    hostname=`hostname`

    if [[ $hostname == "sonic.geo.uu.nl" ]]; then
        export LD_LIBRARY_PATH=$PEACOCK_PREFIX/pcraster/linux/linux/gcc-4/x86_64/lib:$LD_LIBRARY_PATH
        export PCRASTER_PERFORMANCE_DATA=/data/development/project/pcraster/performance/
    elif [[ $hostname == "gransasso" ]]; then
        export LD_LIBRARY_PATH=$PEACOCK_PREFIX/pcraster/linux/linux/gcc-5/x86_64/lib:$LD_LIBRARY_PATH
        export PCRASTER_PERFORMANCE_DATA=/mnt/data1/home/kor/development/project/pcraster/performance
    fi

    unset hostname
fi


export PCRASTER_CMAKE_ARGUMENTS
export PATH PYTHONPATH



unset basename


cd $PCRASTER

# mkvirtualenv --system-site-packages pcraster
workon pcraster

# mkvirtualenv --python /usr/bin/python3 --system-site-packages pcraster_python3
# workon pcraster_python3

pwd
