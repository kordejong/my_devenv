cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd


parse_commandline $*


if [ ! "$NATURAL_CAPITAL_MODELS" ]; then
    export NATURAL_CAPITAL_MODELS="$PROJECTS/`\ls $PROJECTS | \grep -i \"^natural_capital_models$\"`"
fi


# PATH="$NATURAL_CAPITAL_MODELS/environment/script:$NATURAL_CAPITAL_MODELS/source/script:$PATH"
PATH="$NATURAL_CAPITAL_MODELS/source/script:$PATH"
# PYTHONPATH="$NATURAL_CAPITAL_MODELS/source/package:$PYTHONPATH"

# gransasso


# if [[ `hostname` == triklav\.* ]]; then
#     project_data=$HOME/tmp
#     pcraster_prefix=$OBJECTS/Release/pcraster
#     PCRASTER_NR_WORKER_THREADS=2
# elif [[ `hostname` == "gransasso" ]]; then
#     project_data=/mnt/data2/kor/project/natural_capital_models
#     # pcraster_prefix=/opt/pcraster/bin
#     pcraster_prefix=/opt/pcraster-4.2.0-20180112
#     # pcraster_prefix=/opt/pcraster-4.2
#     PCRASTER_NR_WORKER_THREADS=6
# fi

# PATH=$pcraster_prefix/bin:$PATH
# LD_LIBRARY_PATH=$PEACOCK_PREFIX/pcraster/linux/linux/gcc-5/x86_64/lib:$LD_LIBRARY_PATH
# PYTHONPATH=$pcraster_prefix/python:$PYTHONPATH
# unset pcraster_prefix


# export NCM_WORKSPACE=$project_data/data
# export NCM_CONFIGURATION=$NATURAL_CAPITAL_MODELS/environment/configuration/ncm.ini
# export LD_LIBRARY_PATH PATH PYTHONPATH PCRASTER_NR_WORKER_THREADS


# unset project_data


# mkvirtualenv --python `which python2` natural_capital_models
# mkvirtualenv --python `which python3` --system-site-packages natural_capital_models
# workon natural_capital_models

conda activate ncm

cd $NATURAL_CAPITAL_MODELS
