if [ ! "$LECO" ]; then
    export LECO="$PROJECTS/github/kordejong/leco"
fi

if [ ! -d "$LECO" ]; then
    echo "ERROR: directory $LECO does not exist..."
    return 1
fi

cd $LECO

source .venv/bin/activate

if [[ -n $(type -t leco) ]]; then
    unalias leco
fi
