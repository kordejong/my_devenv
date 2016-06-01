if [ ! "$PCRASTER" ]; then
    export PCRASTER="$PROJECTS/`\ls $PROJECTS | \grep -i \"^pcraster$\"`"
fi

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
    -DPCRASTER_BUILD_DOCUMENTATION:BOOL=TRUE
    -DPCRASTER_BUILD_TEST:BOOL=TRUE
"

export PCRASTER_CMAKE_ARGUMENTS
export PATH PYTHONPATH


cd $PCRASTER
pwd
