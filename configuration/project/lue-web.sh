cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*

LUE_WEB="$PROJECTS/`\ls $PROJECTS | \grep -i \"^lue-web$\"`"

basename=`basename $LUE_WEB`

export LUE_WEB

conda activate lue-web

cd $LUE_WEB
pwd
