#!/usr/bin/env bash
set -e

projects=$HOME/Development/projects
personal_files=$projects/personal_files
devenv=$projects/devenv
build_pcrteam_extern=$devenv/scripts/build_pcrteam_extern.sh

build_root=$HOME/tmp/3rd
date=`date +%Y%m%d`
install_root="$HOME/development/PcrTeamExtern/master-$date"

$build_pcrteam_extern $build_root $install_root
