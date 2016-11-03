cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/pcraster.sh

pcraster_version=4
pcraster_prefix=/opt

configure_pcraster $pcraster_prefix $pcraster_version

unset pcraster_version pcraster_prefix
