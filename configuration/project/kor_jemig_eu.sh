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

### cmake_toolchain_file=$EMSDK/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake
### 
### if [ ! -f $cmake_toolchain_file ]; then
###     echo "INFO: No CMake toolchain file found for a $MY_DEVENV_BUILD_TYPE build on $hostname"
###     echo "INFO: Tried $cmake_toolchain_file"
###     echo "INFO: Did you 'source ~/opt/emsdk/emsdk_env.sh --build Release'?"
###     echo "INFO: No worries, you just won't be able to use emscripten now"
### else
###     KOR_JEMIG_EU_CMAKE_ARGUMENTS="
###         $KOR_JEMIG_EU_CMAKE_ARGUMENTS
###         -DCMAKE_TOOLCHAIN_FILE=$cmake_toolchain_file
###     "
### fi


### repository_cache="$HOME/development/repository"
### if [ -d "$repository_cache" ]; then
###     KOR_JEMIG_EU_CMAKE_ARGUMENTS="
###         $KOR_JEMIG_EU_CMAKE_ARGUMENTS
###         -DNOC_REPOSITORY_CACHE:PATH=$repository_cache
###     "
### fi


export KOR_JEMIG_EU
export KOR_JEMIG_EU_CMAKE_ARGUMENTS
export KOR_JEMIG_EU_OBJECTS

conda activate kor_jemig_eu

cd $KOR_JEMIG_EU
pwd
