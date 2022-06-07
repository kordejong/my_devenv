cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*


if [ ! "$PARALLEL_COMPUTING_COURSE" ]; then
    export PARALLEL_COMPUTING_COURSE="$PROJECTS/github/computational_geography/parallel_computing_course"
fi


basename=`basename $PARALLEL_COMPUTING_COURSE`

PARALLEL_COMPUTING_COURSE_OBJECTS="$OBJECTS/$MY_DEVENV_BUILD_TYPE/$basename"

unset basename

export PARALLEL_COMPUTING_COURSE_OBJECTS

cd $PARALLEL_COMPUTING_COURSE

unalias parallel_computing_course 2>/dev/null

hostname=`hostname -s`

conda activate parallel_computing_course

unset hostname
