cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd


parse_commandline $*


if [ ! "$RIVM_AFWEGING" ]; then
    export RIVM_AFWEGING="$PROJECTS/`\ls $PROJECTS | \grep -i \"^rivm_afweging$\"`"
fi

export NC_USER_ID=`id -u`

export PATH="$RIVM_AFWEGING/docker_base/script:$RIVM_AFWEGING/environment/script:$PATH"
export PYTHONPATH="$RIVM_AFWEGING/docker_base/source:$PYTHONPATH"

# gransasso
project_data=/mnt/data2/kor/project/rivm_afweging

export NC_DATA=$project_data/data
export MACHINE_STORAGE_PATH=$project_data/machine
export NC_GEOSERVER_DATA_DIR=$NC_DATA/geoserver
export NC_UPLOADS_DEFAULT_DEST=$NC_DATA/upload

export PATH="$project_data/assessment/bin:$PATH"
export GDX_DATA="$project_data/assessment/data"
export GDX_BIN="$project_data/assessment/bin"

unset project_data

source $RIVM_AFWEGING/environment/configuration/configuration.sh

# mkvirtualenv --python /usr/bin/python3 --system-site-packages rivm_afweging
workon rivm_afweging

cd $RIVM_AFWEGING
