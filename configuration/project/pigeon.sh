export PIGEON="$PROJECTS/`\ls $PROJECTS | \grep -i \"^pigeon$\"`"

basename=`basename $PIGEON`
PATH="$PIGEON/environment/script:$PATH"

if [[ $OSTYPE == "cygwin" ]]; then
    PYTHONPATH="`cygpath -m $OBJECTS`/$basename/bin;$PYTHONPATH"
else
    PYTHONPATH="$OBJECTS/$basename/bin:$PYTHONPATH"
fi

unset basename

PIGEON_CMAKE_ARGUMENTS="
    -DPEACOCK_PREFIX:PATH=$PEACOCK_PREFIX/pigeon
    -DPIGEON_BUILD_CURSES_CLIENT:BOOL=TRUE
    -DPIGEON_BUILD_PYTHON_PACKAGE:BOOL=TRUE
    -DPIGEON_BUILD_DOCUMENTATION:BOOL=TRUE
    -DPIGEON_BUILD_TEST:BOOL=TRUE
"
if [[ $OSTYPE == "cygwin" ]]; then
    PIGEON_CMAKE_ARGUMENTS="
        $PIGEON_CMAKE_ARGUMENTS
        -DCMAKE_MAKE_PROGRAM:STRING=mingw32-make
    "
fi
if [[ $OSTYPE == "darwin14" ]]; then
    PIGEON_CMAKE_ARGUMENTS="
        $PIGEON_CMAKE_ARGUMENTS
        -DCMAKE_PREFIX_PATH:PATH=/opt/local
    "
fi


export PIGEON_CMAKE_ARGUMENTS
export PATH
export PYTHONPATH


cd $PIGEON

# Since there is a command named pigeon, we need to get rid of the alias.
unalias pigeon 2>/dev/null

pwd
