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
# TODO Add when proven to be necessary -DBoost_NO_BOOST_CMAKE:BOOL=TRUE
GGHDC_CMAKE_ARGUMENTS="
    -DPEACOCK_PREFIX:PATH=$PEACOCK_PREFIX/gghdc
"

export GGHDC_CMAKE_ARGUMENTS
# export PATH
# export PYTHONPATH


cd $GGHDC

# Since there is a command named gghdc, we need to get rid of the alias.
unalias gghdc 2>/dev/null

pwd
