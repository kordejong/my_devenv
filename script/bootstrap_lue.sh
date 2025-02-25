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
    cmake_args_hpx="-D CMAKE_POLICY_DEFAULT_CMP0167=OLD"  # -D CMAKE_POLICY_DEFAULT_CMP0169=OLD"
    cmake_args_lue="-D CMAKE_POLICY_DEFAULT_CMP0167=OLD"  # -D CMAKE_POLICY_DEFAULT_CMP0169=OLD"
    conan_packages=""
    lue_preset="${hostname}_${build_type,,}"

    if [[ $hostname == gransasso ]]; then
        compiler="gcc"
        conan_packages="imgui"
        hpx_preset="linux_node"
        lue_preset="${hostname}_conan_${build_type,,}"
        nr_jobs=4
    elif [[ $hostname == hoy ]]; then
        compiler="cl"
        # vcpkg_packages="boost docopt fmt gdal hdf5 hwloc imgui mimalloc nlohmann-json pybind11 span-lite"
        # conan_packages="glfw imgui nlohmann_json vulkan-headers vulkan-loader"
        # conda_prefix=${CONDA_PREFIX//\\//}  # HPX' CMake scripts don't like backslashes
        # cmake_args_hpx="-D Boost_ROOT=$conda_prefix/Library -D Hwloc_ROOT=$conda_prefix/Library"

        # conda_prefix=${CONDA_PREFIX//\\//}  # HPX' CMake scripts don't like backslashes
        # cmake_args_hpx="-D Boost_ROOT=$conda_prefix/Library -D HWLOC_ROOT=$conda_prefix/Library"
        # cmake_args_lue="-D Boost_ROOT=$conda_prefix/Library -D GDAL_ROOT=$conda_prefix/Library"

        boost_root="C:/local/boost_1_85_0"
        hwloc_root="C:/local/hwloc-win64-build-2.11.0"
        gdal_root="C:/local/release-1930-x64-dev/release-1930-x64"

        cmake_args_hpx="$cmake_args_hpx -D Boost_DIR=$boost_root/lib64-msvc-14.3/cmake/Boost-1.85.0 -D Boost_USE_STATIC_LIBS=TRUE -D HPX_WITH_FETCH_HWLOC=TRUE -D HPX_WITH_MALLOC=system"
        # -D HWLOC_ROOT=$hwloc_root"
        cmake_args_lue="$cmake_args_lue -D Boost_DIR=$boost_root/lib64-msvc-14.3/cmake/Boost-1.85.0 -D GDAL_ROOT=$gdal_root -D HDF5_ROOT=$gdal_root"
        # -D LUE_QUALITY_ASSURANCE_WITH_TESTS=FALSE"

        hpx_preset="windows_node"
        nr_jobs=10
    elif [[ $hostname == m1compiler ]]; then
        compiler="clang"
        conan_packages="imgui"
        hpx_preset="macos_node"
        lue_preset="${hostname}_conan_${build_type,,}"
        nr_jobs=4
    elif [[ $hostname == orkney ]]; then
        compiler="gcc"
        conan_packages="imgui"
        hpx_preset="linux_node"
        lue_preset="${hostname}_conan_${build_type,,}"
        cmake_args_hpx="$cmake_args_hpx -D HPX_WITH_FETCH_ASIO=FALSE"  # -D CMAKE_POLICY_DEFAULT_CMP0169=OLD"
        nr_jobs=24
    elif [[ $hostname == snowdon ]]; then
        compiler="gcc"
        conan_packages="imgui"
        hpx_preset="linux_node"
        lue_preset="${hostname}_conan_${build_type,,}"
        nr_jobs=4
    elif [[ $hostname == spider ]]; then
        cmake_args_hpx="$cmake_args_hpx"
        compiler="gcc"
        conan_packages=""
        hpx_preset="cluster"
        nr_jobs=$SLURM_CPUS_ON_NODE
    elif [[ $hostname == velocity ]]; then
        compiler="gcc"
        conan_packages=""
        hpx_preset="linux_node"
        nr_jobs=8
    else
        "Unknown hostname: $hostname"
    fi

    install_prefix=$(realpath $OBJECTS/../opt)/$build_type
    repository_zip_prefix=$(realpath $OBJECTS/../repository)
    hpx_preset="hpx_${build_type,,}_${hpx_preset}_configuration"
    tmp_prefix="/tmp/bootstrap_lue-$USER"

    echo "Setting up $build_type build on $hostname"
    echo "hostname               : $hostname"
    echo "build type             : $build_type"
    echo "conan packages         : $conan_packages"
    echo "compiler               : $compiler"
    echo "cmake_args_hpx         : $cmake_args_hpx"
    echo "cmake_args_lue         : $cmake_args_lue"
    echo "nr parallel jobs to use: $nr_jobs"
    echo "install prefix         : $install_prefix"
    echo "repository zip prefix  : $repository_zip_prefix"
    echo "tmp prefix             : $tmp_prefix"
    echo "hpx preset             : $hpx_preset"
    echo "lue preset             : $lue_preset"

    echo
    echo "An existing LUE CMakeCache will be used. It may make sense to first delete the LUE build directory."
    echo
    read -p "Continue? [y/n] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[y]$ ]]
    then
        exit 1
    fi

    hpx_install_prefix="$install_prefix/hpx"
    mdspan_install_prefix="$install_prefix/mdspan"

    mkdir -p $tmp_prefix
}


function install_hpx()
{
    if [ -d $hpx_install_prefix ]; then
        echo "→ Not installing HPX because it already exists: $hpx_install_prefix"
        return
    fi

    hpx_version="1.10.0"
    hpx_repository_zip="$repository_zip_prefix/v${hpx_version}.tar.gz"

    if [ ! -f $hpx_repository_zip ]; then
        wget --directory-prefix=$repository_zip_prefix https://github.com/STEllAR-GROUP/hpx/archive/refs/tags/v${hpx_version}.tar.gz
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
        $cmake_args_hpx -D CMAKE_BUILD_TYPE=${build_type}
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
    mdspan_tag="9ceface91483775a6c74d06ebf717bbb2768452f"  # 0.6.0

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
    cmake --build $mdspan_build_directory --parallel $nr_jobs --target all
    cmake --install $mdspan_build_directory --prefix $mdspan_install_prefix --strip
    rm -fr $mdspan_source_directory
}


function configure_lue()
{
    source_dir="$LUE"
    build_dir="$OBJECTS/$build_type/lue"
    mkdir -p $build_dir

    ln -s -f $MY_DEVENV/configuration/project/lue/CMakeUserPresets-base.json $source_dir

    if [[ ${conan_packages} ]]; then
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
    else
        ln -s -f $MY_DEVENV/configuration/project/lue/CMakeUserPresets-${build_type}.json $source_dir/CMakeUserPresets.json
    fi

    cmake_hpx_arg="-D LUE_BUILD_HPX=FALSE -D HPX_ROOT=$hpx_install_prefix"

    # Add for profiling (linux, gprof):
    # -D CMAKE_CXX_FLAGS=-pg -D CMAKE_EXE_LINKER_FLAGS=-pg -D CMAKE_SHARED_LINKER_FLAGS=-pg -D CMAKE_MODULE_LINKER_FLAGS=-pg

    cmake -G "Ninja" -S $source_dir --preset ${lue_preset} \
        ${cmake_args_lue} ${cmake_hpx_arg} \
        -D LUE_FRAMEWORK_WITH_IMAGE_LAND=TRUE \
        -D mdspan_ROOT=$mdspan_install_prefix

    ln -s -f $build_dir/compile_commands.json $source_dir
}


parse_command_line $@
configure_builds
install_hpx
install_mdspan
configure_lue

echo -e "\n"
echo "--------------------------------------------------------------------------------------------"
echo "All ready for $build_type builds. Rerun this script before building for other build types!!!"
echo "--------------------------------------------------------------------------------------------"
