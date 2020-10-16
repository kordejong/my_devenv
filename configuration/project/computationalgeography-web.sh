cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*

COMPUTATIONALGEOGRAPHY_WEB="$PROJECTS/`\ls $PROJECTS | \grep -i \"^computationalgeography-web$\"`"

basename=`basename $COMPUTATIONALGEOGRAPHY_WEB`

export COMPUTATIONALGEOGRAPHY_WEB

conda activate computationalgeography-web

cd $COMPUTATIONALGEOGRAPHY_WEB
pwd
