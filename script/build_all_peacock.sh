#!/usr/bin/env bash
set -e



# Peacock packages for Fern:
# rm -fr * && \
#     ~/development/projects/fern/environment/script/peacock.sh \
#         /mnt/data1/home/peacock/download/ \
#         /mnt/data1/home/peacock/fern-20150126 \
#         ~/development/projects/peacock/

# Peacock packages for Lisem:
# rm -fr * && \
#     ~/development/projects/lisem/script/build_3rd_party_software2.sh \
#     /mnt/data1/home/peacock/download/ \
#     /mnt/data1/home/peacock/lisem-20150123 \
#     ~/development/projects/peacock/


cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
personal_files_root=$cwd/../..


function build_peacock_packages()
{
    local hostname=`hostname`
    local peacock_root=$personal_files_root/../peacock
    local peacock_branch=`cd $peacock_root; git branch | grep \* | cut --delimiter=' ' --fields 2 -`
    local date=`date +"%Y%m%d"`

    if [ $hostname == "gransasso" ]; then
        local peacock_prefix=/mnt/data1/home/peacock
        # clang
        local compilers="gcc mingw_32 mingw_64"
    fi

    for compiler in $compilers; do
        build_root=$hostname/${compiler}
        mkdir -p $build_root
        cd $build_root
        rm -fr *

        bash -c "set -e; source $personal_files_root/Environment/Templates/bash/${compiler}_${hostname}.sh; $peacock_root/script/build_all.sh $peacock_prefix/download $peacock_prefix/$peacock_branch-$date"

        cd -
    done
}


build_peacock_packages
