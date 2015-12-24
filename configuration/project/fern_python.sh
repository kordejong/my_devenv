cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd


parse_commandline $*


if [ ! "$FERN_PYTHON" ]; then
    export FERN_PYTHON="$PROJECTS/`\ls $PROJECTS | \grep -i \"^fern_python$\"`"
fi


basename=`basename $FERN_PYTHON`
# PATH="$FERN_PYTHON/environment/script:$PATH"

if [[ $OSTYPE == "cygwin" ]]; then
    PYTHONPATH="`cygpath -m $OBJECTS`/$MY_DEVENV_BUILD_TYPE/$basename/bin;$PYTHONPATH"
else
    PYTHONPATH="$OBJECTS/$MY_DEVENV_BUILD_TYPE/$basename/bin:$PYTHONPATH"
fi

unset basename


common_arguments="
    -DPEACOCK_PREFIX:PATH=$PEACOCK_PREFIX/fern_python
    -DFERN_PYTHON_BUILD_DOCUMENTATION:BOOL=TRUE
    -DFERN_PYTHON_DOCUMENTATION_WITH_DEVELOPER:BOOL=TRUE
    -DFERN_PYTHON_BUILD_TEST:BOOL=TRUE
"
#     -DFERN_PYTHON_WITH_ALL:BOOL=TRUE
FERN_PYTHON_CMAKE_ARGUMENTS="
    $common_arguments
    -DFERN_PYTHON_BUILD_ALL:BOOL=TRUE
"
unset common_arguments


# TODO This version of make must be used when compiling with mingw. It is
#      not dependent on OSTYPE, but on CC.
if [[ $OSTYPE == "cygwin" ]]; then
    FERN_PYTHON_CMAKE_ARGUMENTS="
        $FERN_PYTHON_CMAKE_ARGUMENTS
        -DCMAKE_MAKE_PROGRAM:STRING=mingw32-make
    "
fi

if [[ $CC == "cl" ]]; then
    FERN_PYTHON_CMAKE_ARGUMENTS="
        $FERN_PYTHON_CMAKE_ARGUMENTS
        -DCMAKE_MAKE_PROGRAM:STRING=C:/utils/make
    "
fi


export FERN_PYTHON_CMAKE_ARGUMENTS
# export PATH
export PYTHONPATH


cd $FERN_PYTHON

pwd
