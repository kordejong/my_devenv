cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*

export MY_DOCUMENTS="$PROJECTS/gauja/kordejong/document"

basename=`basename $MY_DOCUMENTS`

MY_DOCUMENTS_OBJECTS="$OBJECTS/$MY_DEVENV_BUILD_TYPE/$basename"

unset basename

export MY_DOCUMENTS_OBJECTS

unalias snippets 2>/dev/null

cd $MY_DOCUMENTS
pwd
