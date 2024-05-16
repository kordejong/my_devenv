cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*


if [ ! "$LUE_DOC" ]; then
    export LUE_DOC="$PROJECTS/github/kordejong/lue_doc"
fi

if [ ! -d "$LUE_DOC" ]; then
    echo "ERROR: directory $LUE_DOC does not exist..."
    return 1
fi

basename=`basename $LUE_DOC`

LUE_DOC_OBJECTS="$OBJECTS/$basename"

unset basename

source $LUE_DOC/env/bin/activate

cd $LUE_DOC

if [[ -n `type -t lue_doc` ]]; then
    unalias lue_doc
fi
