cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd


parse_commandline $*


if [ ! "$FERN" ]; then
    export FERN="$PROJECTS/github/geoneric/fern"
fi

if [ ! -d "$FERN" ]; then
    echo "ERROR: directory $FERN does not exist..."
    return 1
fi

basename=`basename $FERN`

FERN_OBJECTS="$OBJECTS/$MY_DEVENV_BUILD_TYPE/$basename"
PATH="$FERN/environment/script:$PATH"

figure_out_hostname
echo $MY_DEVENV_HOSTNAME

figure_out_cmake_toolchain_file
echo $MY_DEVENV_CMAKE_TOOLCHAIN_FILE


# if [[ $OSTYPE == "cygwin" ]]; then
#     PYTHONPATH="`cygpath -m $LUE_OBJECTS`/bin;$PYTHONPATH"
# else
#     PYTHONPATH="$LUE_OBJECTS/bin:$PYTHONPATH"
# fi
# 
# unset basename


common_arguments="
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
    -DPEACOCK_PREFIX:PATH=$PEACOCK_PREFIX/fern
    -DFERN_BUILD_DOCUMENTATION:BOOL=FALSE
    -DFERN_BUILD_TEST:BOOL=TRUE
    -DFERN_BUILD_BENCHMARK:BOOL=FALSE
    -DCMAKE_TOOLCHAIN_FILE=$MY_DEVENV_CMAKE_TOOLCHAIN_FILE
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

# if [[ $CC == "cl" ]]; then
#     FERN_CMAKE_ARGUMENTS="
#         $FERN_CMAKE_ARGUMENTS
#         -DCMAKE_MAKE_PROGRAM:STRING=C:/utils/make
#     "
# fi


export FERN_CMAKE_ARGUMENTS
export PATH
export PYTHONPATH

cd $FERN

if [[ -n `type -t fern` ]]; then
    unalias fern
fi

conda activate fern
