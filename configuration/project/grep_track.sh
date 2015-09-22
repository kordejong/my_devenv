# vim:syntax=sh

# ------------------------------------------------------------------------------
# DevEnv

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
# GrepTrack

export GREP_TRACK="$PROJECTS/`\ls $PROJECTS | \grep -i \"^grep_track$\"`"

basename=`basename $GREP_TRACK`
PATH="$GREP_TRACK/environment/script:$PATH"
unset basename

GREP_TRACK_CMAKE_ARGUMENTS="
    -DPEACOCK_PREFIX:PATH=$PEACOCK_PREFIX/fern
"
export GREP_TRACK_CMAKE_ARGUMENTS
export PATH


cd $GREP_TRACK

pwd
