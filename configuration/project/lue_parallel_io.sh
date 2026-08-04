if [ ! "$LUE_PARALLEL_IO" ]; then
    export LUE_PARALLEL_IO="$PROJECTS/codeberg/kordejong/lue_parallel_io"
fi

if [ ! -d "$LUE_PARALLEL_IO" ]; then
    echo "ERROR: directory $LUE_PARALLEL_IO does not exist..."
    return 1
fi

hostname=$(hostname -s 2>/dev/null)

if [ ! "$hostname" ]; then
    hostname=$(hostname)
fi

if [ ! "$hostname" ]; then
    echo "Could not figure out the hostname"
    exit 1
fi

if [[ $hostname == jr* ]]; then
    # Jureca
    echo "ERROR: set LUE_PARALLEL_IO_LUE_PREFIX to LUE install prefix"
    echo "ERROR: set LUE_PARALLEL_IO_DATA_PREFIX"
elif [[ $hostname == "orkney" ]]; then
    export LUE_PARALLEL_IO_LUE_PREFIX="$OBJECTS/RelWithDebInfo/lue"
    export LUE_PARALLEL_IO_DATA_PREFIX="/media/data/scratch/kor/data/lue_parallel_io/model/snowmelt"
fi

unset hostname

cd "$LUE_PARALLEL_IO" || exit

unalias LUE_PARALLEL_IO 2>/dev/null

source "$LUE_PARALLEL_IO/.venv/bin/activate"

pwd
