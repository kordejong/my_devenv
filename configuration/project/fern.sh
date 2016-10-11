cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd


parse_commandline $*


if [ ! "$FERN" ]; then
    export FERN="$PROJECTS/`\ls $PROJECTS | \grep -i \"^fern$\"`"
fi


basename=`basename $FERN`
PATH="$FERN/environment/script:$PATH"

if [[ $OSTYPE == "cygwin" ]]; then
    PYTHONPATH="`cygpath -m $OBJECTS`/$MY_DEVENV_BUILD_TYPE/$basename/bin;$PYTHONPATH"
else
    PYTHONPATH="$OBJECTS/$MY_DEVENV_BUILD_TYPE/$basename/bin:$PYTHONPATH"
fi

unset basename


common_arguments="
    -DPEACOCK_PREFIX:PATH=$PEACOCK_PREFIX/fern
    -DFERN_BUILD_DOCUMENTATION:BOOL=TRUE
    -DFERN_BUILD_TEST:BOOL=TRUE
"
# All.
FERN_CMAKE_ARGUMENTS="
    $common_arguments
    -DFERN_BUILD_ALL:BOOL=TRUE
    -DFERN_WITH_ALL:BOOL=TRUE
"
# # HPX development.
# FERN_CMAKE_ARGUMENTS="
#     $common_arguments
#     -DFERN_BUILD_ALGORITHM:BOOL=TRUE
#     -DFERN_ALGORITHM_WITH_HPX:BOOL=TRUE
# "
# Algorithms.
FERN_CMAKE_ARGUMENTS="
    $common_arguments
    -DFERN_BUILD_ALGORITHM:BOOL=TRUE
"
# # I/O, svg
# FERN_CMAKE_ARGUMENTS="
#     $common_arguments
#     -DFERN_BUILD_IO:BOOL=TRUE
#     -DFERN_IO_WITH_SVG:BOOL=TRUE
# "
# # Python extension.
# FERN_CMAKE_ARGUMENTS="
#     $common_arguments
#     -DFERN_BUILD_PYTHON:BOOL=TRUE
# "
unset common_arguments


# # TODO This version of make must be used when compiling with mingw. It is
# #      not dependent on OSTYPE, but on CC.
# if [[ $OSTYPE == "cygwin" ]]; then
#     FERN_CMAKE_ARGUMENTS="
#         $FERN_CMAKE_ARGUMENTS
#         -DCMAKE_MAKE_PROGRAM:STRING=mingw32-make
#     "
# fi

if [[ $CC == "cl" ]]; then
    FERN_CMAKE_ARGUMENTS="
        $FERN_CMAKE_ARGUMENTS
        -DCMAKE_MAKE_PROGRAM:STRING=C:/utils/make
    "
fi


export FERN_CMAKE_ARGUMENTS
export PATH
export PYTHONPATH


cd $FERN

# Since there is a command named fern, we need to get rid of the alias.
unalias fern 2>/dev/null

workon fern

# cd source/fern
pwd
