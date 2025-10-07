cwd=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*

export LUE_QA="$PROJECTS/github/kordejong/lue_qa"

if [ ! -d "$LUE_QA" ]; then
    echo "ERROR: directory $LUE_QA does not exist..."
    return 1
fi

basename=$(basename $LUE_QA)

LUE_QA_OBJECTS="$OBJECTS/$MY_DEVENV_BUILD_TYPE/$basename"

# ...

export LUE_QA LUE_QA_OBJECTS

if [[ -n $(type -t lue_qa) ]]; then
    unalias lue_qa
fi

cd $LUE_QA
source .venv/bin/activate
