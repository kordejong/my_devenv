cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*


if [ ! "$GGHDC" ]; then
    export GGHDC="$PROJECTS/`\ls $PROJECTS | \grep -i \"^gghdc$\"`"
fi


basename=`basename $GGHDC`

PYTHONPATH="$OBJECTS/$MY_DEVENV_BUILD_TYPE/$basename/bin:$PYTHONPATH"

unset basename


# EMIS_DATA="unset"
# hostname=`hostname`
# if [[ $hostname == "sonic.geo.uu.nl" ]]; then
#     EMIS_DATA="/data/development/project/gghdc/archive/archive"
# elif [[ $hostname == "gransasso" ]]; then
#     EMIS_DATA="/mnt/data1/home/kor/data/emis/archive"
# else
#     echo "Warning: EMIS_DATA not set"
# fi
# export EMIS_DATA

export EMIS_SSL=$GGHDC/environment/ssl

# sonic
emis="/data/development/project/emis"
emis_machine="$emis/machine"
emis_data="$emis/data"

export EMIS_UPLOADS_DEFAULT_DEST=$emis_data/upload
# export EMIS_PROPERTY_DATA=$emis_data/property
export EMIS_PROPERTY_DATA=/data/escape/hulp/wgs84/lue
export EMIS_RESULT_DATA=$emis_data/result
export MACHINE_STORAGE_PATH=$emis_machine
unset emis_data emis_machine emis


export EMIS_USER_ID=3013  # jong0137
# export EMIS_GROUP_ID=1000  # pcrdev


PATH=$GGHDC/docker_base/script:$GGHDC/environment/script:$PATH

export PATH

PYTHONPATH=$GGHDC/devbase/source:$GGHDC/docker_base/source:$GGHDC/source:$GGHDC/source/python:$PYTHONPATH

export PYTHONPATH


source $GGHDC/environment/configuration/configuration.sh


cd $GGHDC

# Since there is a command named gghdc, we need to get rid of the alias.
unalias gghdc 2>/dev/null

workon gghdc

pwd
