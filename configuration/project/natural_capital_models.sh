cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd


parse_commandline $*


if [ ! "$NATURAL_CAPITAL_MODELS" ]; then
    export NATURAL_CAPITAL_MODELS="$PROJECTS/`\ls $PROJECTS | \grep -i \"^natural_capital_models$\"`"
fi


export PATH="$NATURAL_CAPITAL_MODELS/environment/script:$NATURAL_CAPITAL_MODELS/source/script:$PATH"
export PYTHONPATH="$NATURAL_CAPITAL_MODELS/source/package:$PYTHONPATH"

# gransasso
project_data=/mnt/data2/kor/project/natural_capital_models

export NCM_WORKSPACE=$project_data/data
export NCM_CONFIGURATION=$NATURAL_CAPITAL_MODELS/environment/configuration/ncm.ini

unset project_data


# mkvirtualenv --python /usr/bin/python2 --system-site-packages natural_capital_models
workon natural_capital_models

cd $NATURAL_CAPITAL_MODELS
