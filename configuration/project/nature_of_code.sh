cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*

NATURE_OF_CODE="$PROJECTS/`\ls $PROJECTS | \grep -i \"^nature_of_code$\"`"

basename=`basename $NATURE_OF_CODE`
NATURE_OF_CODE_OBJECTS="$OBJECTS/$MY_DEVENV_BUILD_TYPE/$basename"

NATURE_OF_CODE_CMAKE_ARGUMENTS="
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
    -DCMAKE_INSTALL_PREFIX:PATH=${TMPDIR:-/tmp}/$MY_DEVENV_BUILD_TYPE/$basename
"

# cmake_toolchain_file=$EMSDK/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake
build_prefix=$HOME/tmp
cmake_toolchain_file=$build_prefix/corrade/toolchains/generic/Emscripten-wasm.cmake

if [ ! -f $cmake_toolchain_file ]; then
    echo "INFO: No CMake toolchain file found for a $MY_DEVENV_BUILD_TYPE build on $hostname"
    echo "INFO: Tried $cmake_toolchain_file"
    echo "INFO: Did you 'source ~/opt/emsdk/emsdk_env.sh --build Release'?"
    echo "INFO: No worries, you just won't be able to use emscripten now"
else
    NATURE_OF_CODE_CMAKE_ARGUMENTS="
        $NATURE_OF_CODE_CMAKE_ARGUMENTS
        -DCMAKE_TOOLCHAIN_FILE=$cmake_toolchain_file
    "
fi


### repository_cache="$HOME/development/repository"
### if [ -d "$repository_cache" ]; then
###     NATURE_OF_CODE_CMAKE_ARGUMENTS="
###         $NATURE_OF_CODE_CMAKE_ARGUMENTS
###         -DNOC_REPOSITORY_CACHE:PATH=$repository_cache
###     "
### fi


export NATURE_OF_CODE
export NATURE_OF_CODE_CMAKE_ARGUMENTS
export NATURE_OF_CODE_OBJECTS

conda activate nature_of_code

cd $NATURE_OF_CODE
pwd
