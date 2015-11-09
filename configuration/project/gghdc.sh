export GGHDC="$PROJECTS/`\ls $PROJECTS | \grep -i \"^gghdc$\"`"

# basename=`basename $GGHDC`
# PATH="$GGHDC/environment/script:$PATH"
# 
# if [[ $OSTYPE == "cygwin" ]]; then
#     PYTHONPATH="`cygpath -m $OBJECTS`/$basename/bin;$PYTHONPATH"
# else
#     PYTHONPATH="$OBJECTS/$basename/bin:$PYTHONPATH"
# fi
# 
# unset basename


# On cartesius, another boost is picked up then the one we want to use. That's
# why there is the -DBoost_NO_BOOST_CMAKE argument.
# -DPEACOCK_PREFIX:PATH=$PEACOCK_PREFIX/gghdc
GGHDC_CMAKE_ARGUMENTS="
    -DBoost_NO_BOOST_CMAKE:BOOL=TRUE
    -DGGHDC_BUILD_DOCUMENTATION:BOOL=TRUE
    -DGGHDC_BUILD_IO:BOOL=TRUE
    -DGGHDC_IO_WITH_MPI:BOOL=TRUE
    -DGGHDC_BUILD_TEST:BOOL=TRUE
"
export GGHDC_CMAKE_ARGUMENTS

cfgs="$GGHDC/environment/configuration"
export GGHDC_AGGREGATE_QUERY_SERVICE_SETTINGS="$cfgs/aggregate_query_service.py"
export GGHDC_AGGREGATE_SERVICE_SETTINGS="$cfgs/aggregate_service.py"
export GGHDC_PORTAL_SERVICE_SETTINGS="$cfgs/portal_service.py"
export GGHDC_PROPERTY_SERVICE_SETTINGS="$cfgs/property_service.py"
export GGHDC_TASK_SERVICE_SETTINGS="$cfgs/task_service.py"
unset cfgs

# export PATH
# export PYTHONPATH


cd $GGHDC

# Since there is a command named gghdc, we need to get rid of the alias.
unalias gghdc 2>/dev/null

pwd
