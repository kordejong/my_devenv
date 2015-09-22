#!/usr/bin/env bash
set -e

projects=$HOME/development/projects

personal_files=$projects/personal_files
bash_templates=$personal_files/Environment/templates/bash

devenv=$projects/devenv
build_pcrteam_extern=$devenv/scripts/build_pcrteam_extern.sh

branch="2.1"

build_root=$HOME/tmp/3rd
install_root="$PCRTEAM_EXTERN_ROOT/$branch-`date +\"%Y%m%d\"`"

### source $bash_templates/lsb_gransasso.sh
### $build_pcrteam_extern $build_root $install_root <<ACCEPT_SETTINGS
### y
### ACCEPT_SETTINGS

source $bash_templates/gcc_gransasso.sh
$build_pcrteam_extern $build_root $install_root <<ACCEPT_SETTINGS
y
ACCEPT_SETTINGS

cd $install_root/..
rm -f $branch && ln -s `basename $install_root` $branch
