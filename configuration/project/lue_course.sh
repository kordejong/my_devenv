cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*


if [ ! "$LUE_COURSE" ]; then
    export LUE_COURSE="$PROJECTS/github/computational_geography/lue_course"
fi


basename=`basename $LUE_COURSE`

LUE_COURSE_OBJECTS="$OBJECTS/$MY_DEVENV_BUILD_TYPE/$basename"

unset basename

export LUE_COURSE_OBJECTS

cd $LUE_COURSE

unalias lue_course 2>/dev/null

hostname=`hostname -s`

source env/bin/activate

unset hostname
