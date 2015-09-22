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
# Nautilus

export NAUTILUS="$PROJECTS/`\ls $PROJECTS | \grep -i \"^nautilus$\"`"

basename=`basename $NAUTILUS`
PATH="$NAUTILUS/environment/script:$PATH"

unset basename

export PATH

cd $NAUTILUS

# Since there is a command named nautilus, we need to get rid of the alias.
unalias nautilus 2>/dev/null

pwd
