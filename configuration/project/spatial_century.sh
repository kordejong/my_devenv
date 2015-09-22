# vim:syntax=sh

export DEVENV_BRANCH=master

_devenv="$PROJECTS/`\ls $PROJECTS | \grep -i \"^devenv$\"`"
_profiles="$_devenv/configuration/profiles"
unset _devenv

source "$_profiles/common" $1
source "$_profiles/DevEnv"
unset _profiles

export SPATIAL_CENTURY="$PROJECTS/`\ls $PROJECTS | \grep -i \"^spatial_century$\"`"

export PATH=$SPATIAL_CENTURY/environment/script:$SPATIAL_CENTURY/source:$PATH

if [ $OSTYPE == "linux-gnu" ]; then
    export CENTURY="wine $HOME/tmp/century_all_files/century_46.exe"
    export LIST100="wine $HOME/tmp/century_all_files/list100_46.exe"
fi

cd $SPATIAL_CENTURY
setPromptForProject spatial_century $BUILD_TYPE

unalias spatial_century 2>/dev/null
