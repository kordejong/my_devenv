if [ ! "$PCRASTER" ]; then
    export PCRASTER="$PROJECTS/`\ls $PROJECTS | \grep -i \"^pcraster$\"`"
fi

PATH="$PCRASTER/environment/script:$PATH"

PCRASTER_CMAKE_ARGUMENTS="
    -DPEACOCK_PREFIX:PATH=$PEACOCK_PREFIX/pcraster
"
if [[ $OSTYPE == "cygwin" ]]; then
    PCRASTER_CMAKE_ARGUMENTS="
        $PCRASTER_CMAKE_ARGUMENTS
        -DCMAKE_MAKE_PROGRAM:STRING=mingw32-make
    "
fi

export PCRASTER_CMAKE_ARGUMENTS
export PATH


cd $PCRASTER
pwd
