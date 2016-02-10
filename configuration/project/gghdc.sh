cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*


if [ ! "$GGHDC" ]; then
    export GGHDC="$PROJECTS/`\ls $PROJECTS | \grep -i \"^gghdc$\"`"
fi


basename=`basename $GGHDC`

if [[ $OSTYPE == "cygwin" ]]; then
    PYTHONPATH="`cygpath -m $OBJECTS`/$MY_DEVENV_BUILD_TYPE/$basename/bin;$PYTHONPATH"
else
    PYTHONPATH="$OBJECTS/$MY_DEVENV_BUILD_TYPE/$basename/bin:$PYTHONPATH"
fi

unset basename


# On cartesius, another boost is picked up then the one we want to use. That's
# why there is the -DBoost_NO_BOOST_CMAKE argument.
# -DPEACOCK_PREFIX:PATH=$PEACOCK_PREFIX/gghdc
GGHDC_CMAKE_ARGUMENTS="
    -DBoost_NO_BOOST_CMAKE:BOOL=TRUE
    -DGGHDC_BUILD_DOCUMENTATION:BOOL=TRUE
    -DGGHDC_BUILD_LUE:BOOL=TRUE
    -DGGHDC_LUE_WITH_MPI:BOOL=FALSE
    -DGGHDC_BUILD_TEST:BOOL=TRUE
    -DPEACOCK_PREFIX:PATH=$PEACOCK_PREFIX/gghdc
"
export GGHDC_CMAKE_ARGUMENTS

cfgs="$GGHDC/environment/configuration"
export GGHDC_AGGREGATE_QUERY_SERVICE_SETTINGS="$cfgs/aggregate_query_service.py"
export GGHDC_AGGREGATE_SERVICE_SETTINGS="$cfgs/aggregate_service.py"
export GGHDC_PORTAL_SERVICE_SETTINGS="$cfgs/portal_service.py"
export GGHDC_PROPERTY_SERVICE_SETTINGS="$cfgs/property_service.py"
export GGHDC_TASK_SERVICE_SETTINGS="$cfgs/task_service.py"
unset cfgs


GGHDC_DATA="unset"
hostname=`hostname`
if [[ $hostname == "sonic.geo.uu.nl" ]]; then
    GGHDC_DATA="/data/development/project/gghdc/data/archive"
fi
export GGHDC_DATA


PATH=$GGHDC/environment/script:$PATH

export PATH


PYTHONPATH=$GGHDC/source:$GGHDC/source/python:$PYTHONPATH

# TODO Make this depend on the build type.
PYTHONPATH=$OBJECTS/Debug/gghdc/bin:$PYTHONPATH

export PYTHONPATH


cd $GGHDC

# Since there is a command named gghdc, we need to get rid of the alias.
unalias gghdc 2>/dev/null

pwd
