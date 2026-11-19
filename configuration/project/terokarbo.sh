cwd=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "$cwd"/util.sh
unset cwd

parse_commandline "$*"

if [ ! "$TEROKARBO" ]; then
    export TEROKARBO="$PROJECTS/codeberg/kordejong/terokarbo"
fi

if [ ! -d "$TEROKARBO" ]; then
    echo "ERROR: directory $TEROKARBO does not exist..."
    return 1
fi

cd "$TEROKARBO" || exit

# linux-gnu, darwin, cygwin, win32, freebsd
if [[ "$OSTYPE" == "msys" ]]; then
    echo "TODO: activate terokarbo Conda environment"
else
    eval "$(~/miniforge3/bin/conda shell.bash hook)"
    conda activate terokarbo
fi

export PYTHONPATH="$TEROKARBO/source/package:$PYTHONPATH"
export PATH="$TEROKARBO/environment/script:$TEROKARBO/source/script:$PATH"

if [[ -n $(type -t terokarbo) ]]; then
    unalias terokarbo
fi
