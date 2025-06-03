cwd=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "$cwd/util.sh"
unset cwd

parse_commandline "$*"

if [ ! "$PLUC_MOZAMBIQUE" ]; then
    export PLUC_MOZAMBIQUE="$PROJECTS/github/kordejong/PLUC_Mozambique"
fi

if [ ! -d "$PLUC_MOZAMBIQUE" ]; then
    echo "ERROR: directory $PLUC_MOZAMBIQUE does not exist..."
    return 1
fi

hostname_=$(hostname -s 2>/dev/null)

if [ ! "$hostname_" ]; then
    hostname_=$(hostname)
fi

if [ ! "$hostname_" ]; then
    echo "Could not figure out the hostname"
    exit 1
fi

hostname_="${hostname_,,}" # Lower-case the hostname

eval "$("$HOME/miniforge3/bin/conda" shell.bash hook)"

conda activate pluc_mozambique

cd "$PLUC_MOZAMBIQUE" || return

if [[ -n $(type -t pluc_mozambique) ]]; then
    unalias pluc_mozambique
fi
