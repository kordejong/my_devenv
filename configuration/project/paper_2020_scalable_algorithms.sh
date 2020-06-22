cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*

if [ ! "$PAPER_2020_SCALABLE_ALGORITHMS" ]; then
    export PAPER_2020_SCALABLE_ALGORITHMS="$PROJECTS/`\ls $PROJECTS | \grep -i \"^paper_2020_scalable_algorithms$\"`"
fi

basename=`basename $PAPER_2020_SCALABLE_ALGORITHMS`
hostname=`hostname -s`

PAPER_2020_SCALABLE_ALGORITHMS_OBJECTS="$OBJECTS/$MY_DEVENV_BUILD_TYPE/$basename"

PAPER_2020_SCALABLE_ALGORITHMS_CMAKE_ARGUMENTS="
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
    -DCMAKE_INSTALL_PREFIX:PATH=${TMPDIR:-/tmp}/$MY_DEVENV_BUILD_TYPE/$basename
    -DPEACOCK_PREFIX:PATH=$PEACOCK_PREFIX/$basename
"

cmake_toolchain_file=$MY_DEVENV/configuration/platform/cmake/$hostname/$MY_DEVENV_BUILD_TYPE.cmake

if [ ! -f $cmake_toolchain_file ]; then
    cmake_toolchain_file=$MY_DEVENV/configuration/platform/cmake/$hostname.cmake
fi

if [ ! -f $cmake_toolchain_file ]; then
    echo "INFO: No CMake toolchain file found for a $MY_DEVENV_BUILD_TYPE build on $hostname"
else
    PAPER_2020_SCALABLE_ALGORITHMS_CMAKE_ARGUMENTS="
        $PAPER_2020_SCALABLE_ALGORITHMS_CMAKE_ARGUMENTS
        -DCMAKE_TOOLCHAIN_FILE=$cmake_toolchain_file
    "
fi

unset cmake_toolchain_file

PYTHONPATH="$PAPER_2020_SCALABLE_ALGORITHMS_OBJECTS/lue/lib:$PYTHONPATH"

export PAPER_2020_SCALABLE_ALGORITHMS_CMAKE_ARGUMENTS
export PAPER_2020_SCALABLE_ALGORITHMS_OBJECTS
export PYTHONPATH

cd $PAPER_2020_SCALABLE_ALGORITHMS

unalias $basename 2>/dev/null

conda activate $basename

unset basename
unset hostname

pwd
