cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*

HPC_CLASSROOM="$PROJECTS/`\ls $PROJECTS | \grep -i \"^hpc-classroom$\"`"

basename=`basename $HPC_CLASSROOM`

export HPC_CLASSROOM

conda activate hpc-classroom

cd $HPC_CLASSROOM
pwd
