#!/usr/bin/env bash
set -e

projects=$HOME/Development/projects

personal_files=$projects/personal_files
bash_templates=$personal_files/Environment/Templates/bash

devenv=$projects/DevEnv
build_pcrteam_extern=$devenv/scripts/build_pcrteam_extern.sh

build_root=$HOME/tmp/3rd
install_root="$HOME/Development/PcrTeamExtern/master-`date +\"%Y%m%d\"`"
# install_root="$HOME/Development/PcrTeamExtern/master-20130102"

# unset CC
# unset CXX
# # source $bash_templates/gcc_triklav.sh
# $build_pcrteam_extern $build_root $install_root

source $bash_templates/clang_triklav.sh
$build_pcrteam_extern -p $build_root $install_root
