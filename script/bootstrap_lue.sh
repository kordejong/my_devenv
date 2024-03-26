#!/usr/bin/env bash
set -euo pipefail


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


function parse_command_line()
{
    usage="$(basename $0) hostname build_type"

    if [[ $# != 2 ]];
    then
        echo $usage
        exit 1
    fi

    hostname=$1
    build_type=$2
}


function configure_builds()
{
    cmake_args=""

    if [[ $hostname == gransasso ]]; then
        compiler="gcc"
        conan_packages="imgui"
        hpx_preset="linux_node"
        nr_jobs=4
    elif [[ $hostname == hoy ]]; then
        compiler="cl"
        # vcpkg_packages="boost docopt fmt gdal hdf5 hwloc imgui mimalloc nlohmann-json pybind11 span-lite"
        conan_packages="docopt.cpp glfw imgui nlohmann_json vulkan-headers vulkan-loader"
        conda_prefix=${CONDA_PREFIX//\\//}  # HPX' CMake scripts don't like backslashes
        cmake_args="-D BOOST_ROOT=$conda_prefix/Library -D HWLOC_ROOT=$conda_prefix/Library"
        hpx_preset="windows_node"
        nr_jobs=8
    elif [[ $hostname == m1compiler ]]; then
        compiler="clang"
        conan_packages="docopt.cpp imgui"
        hpx_preset="macos_node"
        nr_jobs=4
    elif [[ $hostname == orkney ]]; then
        compiler="gcc"
        conan_packages="imgui"
        hpx_preset="linux_node"
        nr_jobs=24
    elif [[ $hostname == snowdon ]]; then
        compiler="gcc"
        conan_packages="imgui"
        hpx_preset="linux_node"
        nr_jobs=4
    elif [[ $hostname == velocity ]]; then
        compiler="gcc"
        conan_packages="docopt.cpp"
        hpx_preset="linux_node"
        nr_jobs=24
    else
        "Unknown hostname: $hostname"
    fi

    install_prefix=$(realpath $PROJECTS/../opt)/$build_type
    repository_zip_prefix=$(realpath $PROJECTS/../repository)
    tmp_prefix=~/tmp
    hpx_preset="hpx_${build_type,,}_${hpx_preset}_configuration"


    echo "Setting up $build_type build on $hostname"
    echo "hostname               : $hostname"
    echo "build type             : $build_type"
    echo "conan packages         : $conan_packages"
    echo "compiler               : $compiler"
    echo "cmake_args             : $cmake_args"
    echo "nr parallel jobs to use: $nr_jobs"
    echo "install prefix         : $install_prefix"
    echo "repository zip prefix  : $repository_zip_prefix"
    echo "tmp prefix             : $tmp_prefix"
    echo "hpx preset             : $hpx_preset"

    echo
    read -p "Are you sure [yn]? " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[y]$ ]]
    then
        exit 1
    fi

    hpx_install_prefix="$install_prefix/hpx"
    mdspan_install_prefix="$install_prefix/mdspan"
}


function install_hpx()
{
    if [ -d $hpx_install_prefix ]; then
        echo "→ Not installing HPX because it already exists: $hpx_install_prefix"
        return
    fi

    hpx_version="1.9.1"
    hpx_repository_zip="$repository_zip_prefix/v${hpx_version}.tar.gz"

    if [ ! -f $hpx_repository_zip ]; then
        wget --directory_prefix=$repository_zip_prefix https://github.com/STEllAR-GROUP/hpx/archive/refs/tags/v${hpx_version}.tar.gz
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
        -D CMAKE_POLICY_DEFAULT_CMP0144=NEW \
        $cmake_args -D CMAKE_BUILD_TYPE=${build_type}
    cmake --build $hpx_build_directory --parallel $nr_jobs --target all
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
    mdspan_tag="721efd8"  # 20240305

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
        -D CMAKE_POLICY_DEFAULT_CMP0144=NEW \
        -D CMAKE_BUILD_TYPE=${build_type}
    cmake --build $mdspan_build_directory --parallel $nr_jobs --target all
    cmake --install $mdspan_build_directory --prefix $mdspan_install_prefix --strip
    rm -fr $mdspan_source_directory
}


function configure_lue()
{
    source_dir="$LUE"
    build_dir="$OBJECTS/conan/$build_type/lue"

    mkdir -p $build_dir

    ln -s -f $MY_DEVENV/configuration/project/lue/CMakeUserPresets-base.json $source_dir

    python "$source_dir/environment/script/write_conan_profile.py" $compiler $source_dir/host_profile
    python "$source_dir/environment/script/write_conan_profile.py" $compiler $source_dir/build_profile

    LUE_CONAN_PACKAGES="$conan_packages" \
        conan install $source_dir \
            --profile:host=$source_dir/host_profile \
            --profile:build=$source_dir/build_profile \
            --settings=build_type=$build_type \
            --build=missing \
            --output-folder=$build_dir

    ln -s -f $MY_DEVENV/configuration/project/lue/CMakeUserPresets-Conan${build_type}.json $source_dir/CMakeUserPresets.json
    ln -s -f $build_dir/CMakePresets.json $source_dir/CMakeConanPresets.json

    cmake_hpx_arg="-D LUE_BUILD_HPX=FALSE -D HPX_ROOT=$hpx_install_prefix"

    # Add for profiling (linux, gprof):
    # -D CMAKE_CXX_FLAGS=-pg -D CMAKE_EXE_LINKER_FLAGS=-pg -D CMAKE_SHARED_LINKER_FLAGS=-pg -D CMAKE_MODULE_LINKER_FLAGS=-pg

    cmake -S $source_dir --preset ${hostname}_conan_${build_type,,} \
        -D CMAKE_POLICY_DEFAULT_CMP0144=NEW \
        ${cmake_hpx_arg} \
        -D MDSPAN_ROOT=$mdspan_install_prefix

    ln -s -f $build_dir/compile_commands.json $source_dir
}


parse_command_line $@
configure_builds
install_hpx
install_mdspan
configure_lue
