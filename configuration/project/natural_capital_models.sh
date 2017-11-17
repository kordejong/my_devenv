cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd


parse_commandline $*


if [ ! "$NATURAL_CAPITAL_MODELS" ]; then
    export NATURAL_CAPITAL_MODELS="$PROJECTS/`\ls $PROJECTS | \grep -i \"^natural_capital_models$\"`"
fi


PATH="$NATURAL_CAPITAL_MODELS/environment/script:$NATURAL_CAPITAL_MODELS/source/script:$PATH"
PYTHONPATH="$NATURAL_CAPITAL_MODELS/source/package:$PYTHONPATH"

# gransasso


if [[ `hostname` == triklav\.* ]]; then

    project_data=$HOME/tmp

    pcraster_prefix=$OBJECTS/Debug/pcraster
    PATH=$pcraster_prefix/bin:$PATH
    PYTHONPATH=$pcraster_prefix/bin:$PYTHONPATH
    unset pcraster_prefix
elif [[ `hostname` == "gransasso" ]]; then
    project_data=/mnt/data2/kor/project/natural_capital_models

    PATH=$PATH:/opt/pcraster/bin
    PYTHONPATH=$PYTHONPATH:/opt/pcraster/python
fi

export NCM_WORKSPACE=$project_data/data
export NCM_CONFIGURATION=$NATURAL_CAPITAL_MODELS/environment/configuration/ncm.ini
export PATH PYTHONPATH


unset project_data


# mkvirtualenv --python /usr/bin/python2 --system-site-packages natural_capital_models
# mkvirtualenv --python `which python3.5` --system-site-packages natural_capital_models
workon natural_capital_models

cd $NATURAL_CAPITAL_MODELS
