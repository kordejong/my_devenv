#!/usr/bin/env bash
set -e


if [ -z ${MY_DEVENV+x} ];
then
    echo "\$MY_DEVENV is unset"
    exit 1
fi

if [ -z ${LUE+x} ];
then
    echo "\$LUE is unset"
    exit 1
fi

if [ -z ${OBJECTS+x} ];
then
    echo "\$OBJECTS is unset"
    exit 1
fi

build_type="Release"
build_type="Debug"
hostname="snowdon"
source_dir="$LUE"
build_dir="$OBJECTS/conan/$build_type/lue"

python "$source_dir/environment/script/write_conan_profile.py" gcc $source_dir/host_profile
python "$source_dir/environment/script/write_conan_profile.py" gcc $source_dir/build_profile

mkdir -p $build_dir

LUE_CONAN_PACKAGES="imgui pybind11 span-lite" \
    conan install $source_dir \
        --profile:host=$source_dir/host_profile \
        --profile:build=$source_dir/build_profile \
        --settings=build_type=$build_type \
        --build=missing \
        --output-folder=$build_dir

ln -s --force $MY_DEVENV/configuration/project/lue/CMakeUserPresets.json $source_dir

ln -s --force $build_dir/CMakePresets.json $source_dir/CMakeConanPresets.json
cmake -S $source_dir --preset ${hostname}_conan_debug

ln -s --force $build_dir/compile_commands.json $source_dir
