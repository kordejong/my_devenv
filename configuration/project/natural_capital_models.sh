cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd


parse_commandline $*


if [ ! "$NATURAL_CAPITAL_MODELS" ]; then
    export NATURAL_CAPITAL_MODELS="$PROJECTS/github/rivm-syso/natural_capital_models"
fi

if [ ! -d "$NATURAL_CAPITAL_MODELS" ]; then
    echo "ERROR: directory $NATURAL_CAPITAL_MODELS does not exist..."
    return 1
fi

# PATH="$NATURAL_CAPITAL_MODELS/environment/script:$NATURAL_CAPITAL_MODELS/source/script:$PATH"
PATH="$NATURAL_CAPITAL_MODELS/source/script:$PATH"
PYTHONPATH="$NATURAL_CAPITAL_MODELS/source/package:$PYTHONPATH"

# gransasso


if [[ `hostname` == triklav\.* ]]; then
    project_data=$HOME/tmp
    PCRASTER_NR_WORKER_THREADS=2
elif [[ `hostname` == "gransasso" ]]; then
    project_data=/mnt/data2/kor/project/natural_capital_models
    PCRASTER_NR_WORKER_THREADS=6
fi


export NCM_WORKSPACE=$project_data/data
export NCM_CONFIGURATION=$NATURAL_CAPITAL_MODELS/environment/configuration/ncm.ini
export PATH PYTHONPATH PCRASTER_NR_WORKER_THREADS

unset project_data

conda activate ncm

cd $NATURAL_CAPITAL_MODELS
