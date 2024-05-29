cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd

parse_commandline $*


if [ ! "$PCR_GLOBWB" ]; then
    export PCR_GLOBWB="$PROJECTS/github/kordejong/pcr_globwb"
fi

if [ ! -d "$PCR_GLOBWB" ]; then
    echo "ERROR: directory $PCR_GLOBWB does not exist..."
    return 1
fi

hostname_=`hostname -s 2>/dev/null`

if [ ! "$hostname_" ];
then
    hostname_=`hostname`
fi

if [ ! "$hostname_" ];
then
    echo "Could not figure out the hostname"
    exit 1
fi

hostname_="${hostname_,,}"  # Lower-case the hostname

if [[ $hostname_ == "velocity" ]];
then
    eval "$(/developtest/miniforge3/bin/conda shell.bash hook)"
fi

conda activate pcr_globwb

cd $PCR_GLOBWB

if [[ -n `type -t pcr_globwb` ]]; then
    unalias pcr_globwb
fi
