# vim:syntax=sh

# source $PERSONAL_FILES/Environment/project/devenv_basic.sh

export DEVENV_BRANCH=2.1
export DAL_BRANCH=1.3
export RASTERFORMAT_BRANCH=1.3
export PCRTREE2_BRANCH=4.0

_devenv="$PROJECTS/`\ls $PROJECTS | \grep -i \"^devenv$\"`"
_profiles="$_devenv/configuration/profiles"
unset _devenv

source "$_profiles/common" $1
source "$_profiles/DevEnv"
source "$_profiles/RasterFormat"
source "$_profiles/Dal"
source "$_profiles/PcrTree2"
unset _profiles







MAPS4SOCIETY="$PROJECTS/`\ls $PROJECTS | \grep -i \"^maps4society$\"`"
PATH="$MAPS4SOCIETY/environment/script:$PATH"
MAPS4SOCIETY_CMAKE_ARGUMENTS="
    -DPEACOCK_PREFIX:PATH=$PEACOCK_PREFIX/maps4society
"

export MAPS4SOCIETY_CMAKE_ARGUMENTS
export PATH
export MAPS4SOCIETY

cd $MAPS4SOCIETY

pwd
