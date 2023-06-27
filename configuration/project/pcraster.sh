cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd


parse_commandline $*


if [ ! "$PCRASTER" ]; then
    export PCRASTER="$PROJECTS/github/pcraster/pcraster"
fi

if [ ! -d "$PCRASTER" ]; then
    echo "ERROR: directory $PCRASTER does not exist..."
    return 1
fi

basename=`basename $PCRASTER`

PATH="$PCRASTER/environment/script:$PATH"
PYTHONPATH="$PCRASTER/devbase/source:$PYTHONPATH"


PCRASTER_OBJECTS="$OBJECTS/$MY_DEVENV_BUILD_TYPE/$basename"
PATH="$PCRASTER_OBJECTS/bin:$PATH"
PYTHONPATH="$PCRASTER/source:$PCRASTER_OBJECTS/bin:$PYTHONPATH"


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


export PATH PYTHONPATH



unset basename


cd $PCRASTER


# conda activate pcraster

# mkvirtualenv --python `which python3` --system-site-packages pcraster
# workon pcraster


# This code uses `which python`, so it must come after the workon/conda
# statement
PCRASTER_CMAKE_ARGUMENTS="
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
    -DPEACOCK_PREFIX:PATH=$PEACOCK_PREFIX/pcraster
    -DPCRASTER_BUILD_DOCUMENTATION:BOOL=FALSE
    -DPCRASTER_BUILD_TEST:BOOL=TRUE
    -DPCRASTER_BUILD_BLOCKPYTHON=TRUE
    -DPCRASTER_WITH_PYTHON_MULTICORE=TRUE
    -DFERN_BUILD_ALGORITHM:BOOL=TRUE
    -DPYTHON_EXECUTABLE=`which python`
"
if [[ $OSTYPE == "cygwin" ]]; then
    PCRASTER_CMAKE_ARGUMENTS="
        $PCRASTER_CMAKE_ARGUMENTS
        -DCMAKE_MAKE_PROGRAM:STRING=mingw32-make
    "
fi

if [[ `hostname` == "triklav" ||
        `hostname` == "triklav.local" ||
        `hostname` == "triklav.soliscom.uu.nl"
        ]]; then
    PCRASTER_CMAKE_ARGUMENTS="
        $PCRASTER_CMAKE_ARGUMENTS
        -DCMAKE_PREFIX_PATH=/opt/local/libexec/qt5
    "
fi
export PCRASTER_CMAKE_ARGUMENTS


pwd
