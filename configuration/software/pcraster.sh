function configure_pcraster()
{
    local pcraster_prefix=$1
    local pcraster_version=$2
    local pcraster_root=$pcraster_prefix/pcraster-$pcraster_version

    export PATH=$pcraster_root/bin:$PATH
    export PYTHONPATH=$pcraster_root/python:$PYTHONPATH
    export LD_LIBRARY_PATH=$pcraster_root/lib:$LD_LIBRARY_PATH
}
