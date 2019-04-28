cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*

if [ ! "$PAPER_2019_PHYSICAL_DATA_MODEL" ]; then
    export PAPER_2019_PHYSICAL_DATA_MODEL="$PROJECTS/`\ls $PROJECTS | \grep -i \"^paper_2019_physical_data_model$\"`"
fi

basename=`basename $PAPER_2019_PHYSICAL_DATA_MODEL`
hostname=`hostname -s`

PAPER_2019_PHYSICAL_DATA_MODEL_OBJECTS="$OBJECTS/$MY_DEVENV_BUILD_TYPE/$basename"

PAPER_2019_PHYSICAL_DATA_MODEL_CMAKE_ARGUMENTS="
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
    PAPER_2019_PHYSICAL_DATA_MODEL_CMAKE_ARGUMENTS="
        $PAPER_2019_PHYSICAL_DATA_MODEL_CMAKE_ARGUMENTS
        -DCMAKE_TOOLCHAIN_FILE=$cmake_toolchain_file
    "
fi

unset cmake_toolchain_file

PYTHONPATH="$PAPER_2019_PHYSICAL_DATA_MODEL_OBJECTS/lue/lib:$PYTHONPATH"

export PAPER_2019_PHYSICAL_DATA_MODEL_CMAKE_ARGUMENTS
export PAPER_2019_PHYSICAL_DATA_MODEL_OBJECTS
export PYTHONPATH

cd $PAPER_2019_PHYSICAL_DATA_MODEL

unalias $basename 2>/dev/null

conda activate $basename

unset basename
unset hostname

pwd
