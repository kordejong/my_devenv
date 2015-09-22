# vim:syntax=sh

# Pick the stuff from DevEnv we want (Python scripts) and nothing else.
export DEVENV_BRANCH=master
devenv="$PROJECTS/`\ls $PROJECTS | \grep -i \"^devenv$\"`"
profiles="$devenv/configuration/profiles"
source "$profiles/common" $1
unset profiles

PATH="$devenv/scripts:$PATH"

if [[ $OSTYPE == "cygwin" ]]; then
    PYTHONPATH="`cygpath -m $devenv`/sources;$PYTHONPATH"
else
    PYTHONPATH="$devenv/sources:$PYTHONPATH"
fi

unset devenv

# Get rid of DevEnv variables.
unset DEVENV_BRANCH
unset PCRTEAM_EXTERN
unset PCRTEAM_EXTERN_ROOT
unset PCRTEAM_PLATFORM


# ------------------------------------------------------------------------------
# Lisem

export LISEM="$PROJECTS/`\ls $PROJECTS | \grep -i \"^lisem$\"`"

LISEM_CMAKE_ARGUMENTS="-DPEACOCK_PREFIX:PATH=$PEACOCK_PREFIX/lisem"
if [[ $OSTYPE == "cygwin" ]]; then
    LISEM_CMAKE_ARGUMENTS="$LISEM_CMAKE_ARGUMENTS -DCMAKE_MAKE_PROGRAM:STRING=mingw32-make"
else
    LISEM_CMAKE_ARGUMENTS="$LISEM_CMAKE_ARGUMENTS"
fi
export LISEM_CMAKE_ARGUMENTS

cd $LISEM
setPromptForProject lisem $BUILD_TYPE

# Since there is a command named lisem, we need to get rid of the alias.
unalias lisem 2>/dev/null

pwd
