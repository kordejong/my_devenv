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


usage="$(basename $0) hostname build_type"


if [[ $# != 2 ]];
then
    echo $usage
    exit 1
fi

hostname=$1
build_type=$2

if [[ $hostname == gransasso ]]; then
    compiler="gcc"
    conan_packages="imgui pybind11 span-lite"
elif [[ $hostname == m1compiler ]]; then
    compiler="clang"
    conan_packages="docopt.cpp imgui span-lite"
elif [[ $hostname == velocity ]]; then
    compiler="gcc"
    conan_packages="docopt.cpp pybind11 span-lite"
else
    "Unknown hostname: $hostname"
fi

echo "Setting up $build_type build on $hostname"
echo "hostname      : $hostname"
echo "build type    : $build_type"
echo "conan packages: $conan_packages"
echo "compiler      : $compiler"

source_dir="$LUE"
build_dir="$OBJECTS/conan/$build_type/lue"

python "$source_dir/environment/script/write_conan_profile.py" $compiler $source_dir/host_profile
python "$source_dir/environment/script/write_conan_profile.py" $compiler $source_dir/build_profile

mkdir -p $build_dir

LUE_CONAN_PACKAGES="$conan_packages" \
    conan install $source_dir \
        --profile:host=$source_dir/host_profile \
        --profile:build=$source_dir/build_profile \
        --settings=build_type=$build_type \
        --build=missing \
        --output-folder=$build_dir

ln -s -f $MY_DEVENV/configuration/project/lue/CMakeUserPresets-base.json $source_dir
ln -s -f $MY_DEVENV/configuration/project/lue/CMakeUserPresets-Conan${build_type}.json $source_dir/CMakeUserPresets.json
ln -s -f $build_dir/build/${build_type}/generators/CMakePresets.json $source_dir/CMakeConanPresets.json

cmake -S $source_dir --preset ${hostname}_conan_${build_type,,}

ln -s -f $build_dir/compile_commands.json $source_dir
