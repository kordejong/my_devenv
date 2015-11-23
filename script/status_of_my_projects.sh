#!/usr/bin/env bash
set -e

cd $PROJECTS

projects="
    my_devenv
    personal_files
    geoneric
    fern
    gghdc
    maps4society
    rivm_atlas
"

for project in $projects; do
    cd $project
    pwd
    git status --short
    cd ..
done
