#!/usr/bin/env bash
set -e
set -x


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
    hpx_preset="node"
elif [[ $hostname == m1compiler ]]; then
    compiler="clang"
    conan_packages="docopt.cpp imgui span-lite"
    hpx_preset="node"
elif [[ $hostname == orkney ]]; then
    compiler="gcc"
    conan_packages="imgui"
    hpx_preset="node"
elif [[ $hostname == snowdon ]]; then
    compiler="gcc"
    conan_packages="imgui"
    hpx_preset="node"
elif [[ $hostname == velocity ]]; then
    compiler="gcc"
    conan_packages="docopt.cpp pybind11 span-lite"
    hpx_preset="node"
else
    "Unknown hostname: $hostname"
fi

install_prefix=$(realpath $PROJECTS/../opt)/$build_type
repository_zip_prefix=$(realpath $PROJECTS/../repository)
tmp_prefix=~/tmp
hpx_preset="hpx_${build_type,,}_${hpx_preset}_configuration"


echo "Setting up $build_type build on $hostname"
echo "hostname             : $hostname"
echo "build type           : $build_type"
echo "conan packages       : $conan_packages"
echo "compiler             : $compiler"
echo "install prefix       : $install_prefix"
echo "repository zip prefix: $repository_zip_prefix"
echo "tmp prefix           : $tmp_prefix"
echo "hpx preset           : $hpx_preset"


hpx_install_prefix="$install_prefix/hpx"
mdspan_install_prefix="$install_prefix/mdspan"


function install_hpx()
{
    if [ -d $hpx_install_prefix ]; then
        echo "→ Not installing HPX because it already exists: $hpx_install_prefix"
        return
    fi

    hpx_version="1.9.1"
    hpx_repository_zip="$repository_zip_prefix/v${hpx_version}.tar.gz"

    if [ ! -f $hpx_repository_zip ]; then
        # TODO
        wget --directory_prefix=$repository_zip_prefix https://github.com/STEllAR-GROUP/mehmeh/v1.9.1.tar.gz
    fi

    hpx_source_directory="$tmp_prefix/hpx-${hpx_version}"
    hpx_build_directory="$hpx_source_directory/build"

    if [ -d $hpx_source_directory ]; then
        rm -fr $hpx_source_directory
    fi

    tar -zx --directory=$(dirname $hpx_source_directory) --file $hpx_repository_zip
    cp $LUE/CMakeHPXPresets.json $hpx_source_directory/CMakeUserPresets.json
    mkdir $hpx_build_directory
    cmake -G "Ninja" -S $hpx_source_directory -B $hpx_build_directory --preset ${hpx_preset} \
        -D CMAKE_BUILD_TYPE=${build_type}
    cmake --build $hpx_build_directory --target all
    cmake --install $hpx_build_directory --prefix $hpx_install_prefix --strip
    rm -fr $hpx_source_directory
}


function install_mdspan()
{
    if [ -d $mdspan_install_prefix ]; then
        echo "→ Not installing mdspan because it already exists: $mdspan_install_prefix"
        return
    fi

    mdspan_repository_url="https://github.com/kokkos/mdspan.git"
    mdspan_tag="a799088"  # 20191010

    mdspan_source_directory="$tmp_prefix/mdspan"
    mdspan_build_directory="$mdspan_source_directory/build"

    if [ -d $mdspan_source_directory ]; then
        rm -fr $mdspan_source_directory
    fi

    git clone $mdspan_repository_url $mdspan_source_directory
    cd $mdspan_source_directory
    git checkout $mdspan_tag
    cd -

    mkdir $mdspan_build_directory
    cmake -G "Ninja" -S $mdspan_source_directory -B $mdspan_build_directory \
        -D CMAKE_BUILD_TYPE=${build_type}
    cmake --build $mdspan_build_directory --target all
    cmake --install $mdspan_build_directory --prefix $mdspan_install_prefix --strip
    rm -fr $mdspan_source_directory
}


function configure_lue()
{
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
    ln -s -f $build_dir/CMakePresets.json $source_dir/CMakeConanPresets.json

    cmake -S $source_dir --preset ${hostname}_conan_${build_type,,} \
        -D LUE_BUILD_HPX=FALSE \
        -D CMAKE_POLICY_DEFAULT_CMP0144=NEW \
        -D HPX_ROOT=$hpx_install_prefix \
        -D MDSPAN_ROOT=$mdspan_install_prefix

    ln -s -f $build_dir/compile_commands.json $source_dir
}


install_hpx
install_mdspan
configure_lue
