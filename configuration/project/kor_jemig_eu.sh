cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*

KOR_JEMIG_EU="$PROJECTS/`\ls $PROJECTS | \grep -i \"^kor_jemig_eu$\"`"

basename=`basename $KOR_JEMIG_EU`
KOR_JEMIG_EU_OBJECTS="$OBJECTS/$MY_DEVENV_BUILD_TYPE/$basename"

KOR_JEMIG_EU_CMAKE_ARGUMENTS="
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
    -DCMAKE_INSTALL_PREFIX:PATH=${TMPDIR:-/tmp}/$MY_DEVENV_BUILD_TYPE/$basename
"

cmake_toolchain_file=$EMSDK/fastcomp/emscripten/cmake/Modules/Platform/Emscripten.cmake

if [ ! -f $cmake_toolchain_file ]; then
    echo "INFO: No CMake toolchain file found for a $MY_DEVENV_BUILD_TYPE build on $hostname"
    echo "INFO: Tried $cmake_toolchain_file"
else
    KOR_JEMIG_EU_CMAKE_ARGUMENTS="
        $KOR_JEMIG_EU_CMAKE_ARGUMENTS
        -DCMAKE_TOOLCHAIN_FILE=$cmake_toolchain_file
    "
fi

export KOR_JEMIG_EU
export KOR_JEMIG_EU_CMAKE_ARGUMENTS
export KOR_JEMIG_EU_OBJECTS

conda activate kor_jemig_eu

cd $KOR_JEMIG_EU
pwd
