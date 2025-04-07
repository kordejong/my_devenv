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

if [ -z ${USER+x} ];
then
    username=$USERNAME
else
    username=$USER
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

    if [[ $hostname == eejit ]]; then
        compiler="gcc"
        hpx_preset="cluster"
        nr_jobs=$SLURM_CPUS_ON_NODE
    elif [[ $hostname == gransasso ]]; then
        compiler="gcc"
        conan_packages="imgui"
        hpx_preset="linux_node"
        lue_preset="${hostname}_conan_${build_type,,}"
        nr_jobs=4
    elif [[ $hostname == hoy ]]; then
        cmake_args_lue="$cmake_args_lue -D LUE_FRAMEWORK_SIGNED_INTEGRAL_ELEMENTS=std::int32_t -D LUE_FRAMEWORK_UNSIGNED_INTEGRAL_ELEMENTS=std::uint8_t -D LUE_FRAMEWORK_FLOATING_POINT_ELEMENTS=float -D LUE_FRAMEWORK_BOOLEAN_ELEMENT=std::uint8_t -D LUE_FRAMEWORK_COUNT_ELEMENT=std::int32_t -D LUE_FRAMEWORK_INDEX_ELEMENT=std::int32_t -D LUE_FRAMEWORK_ID_ELEMENT=std::int32_t"
        compiler="cl"
        # TODO Can't be used because HPX' and Conan's CMake logic aren't compatible: asio, hwloc. Sigh...
        conan_packages="boost cxxopts gdal glfw imgui hdf5 mimalloc nlohmann_json pybind11 vulkan-headers vulkan-loader"
        hpx_preset="windows_node"
        # TODO Finding Conan's jemalloc doesn't work. Sigh...
        # TODO linking against Conan's mimalloc doesn't work. Sigh...
        cmake_args_hpx="${cmake_args_hpx} -D CMAKE_POLICY_DEFAULT_CMP0169=OLD -D HPX_WITH_MALLOC=system"
        lue_preset="${hostname}_conan_${build_type,,}"
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
        cmake_args_hpx="$cmake_args_hpx"
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

    if [[ ${conan_packages} ]]; then
        hpx_preset="${hpx_preset}_conan"
    fi

    hpx_preset="hpx_${build_type,,}_${hpx_preset}_configuration"

    tmp_prefix="/tmp/bootstrap_lue-$username"
    hpx_version="1.10.0"
    hpx_source_directory="$tmp_prefix/hpx-${hpx_version}"
    hpx_build_directory="$hpx_source_directory/build"
    hpx_install_prefix="$install_prefix/hpx"
    mdspan_install_prefix="$install_prefix/mdspan"
    lue_source_directory="$LUE"
    lue_build_directory="$OBJECTS/$build_type/lue"

    cmake_args_lue=" \
        $cmake_args_lue \
        -D CMAKE_VERIFY_INTERFACE_HEADER_SETS=TRUE \
        -D HPX_ROOT=$hpx_install_prefix \
        -D mdspan_ROOT=$mdspan_install_prefix \
        -D LUE_BUILD_HPX=FALSE \
        -D LUE_FRAMEWORK_WITH_IMAGE_LAND=TRUE
    "

    echo "Setting up $build_type build on $hostname"
    echo "hostname               : $hostname"
    echo "build type             : $build_type"
    echo "conan_packages         : $conan_packages"
    echo "compiler               : $compiler"
    echo "cmake_args_hpx         : $cmake_args_hpx"
    echo "cmake_args_lue         : "$cmake_args_lue
    echo "nr parallel jobs to use: $nr_jobs"
    echo "install prefix         : $install_prefix"
    echo "repository zip prefix  : $repository_zip_prefix"
    echo "tmp prefix             : $tmp_prefix"
    echo "hpx_version            : $hpx_version"
    echo "hpx_source_directory   : $hpx_source_directory"
    echo "hpx_build_directory    : $hpx_build_directory"
    echo "hpx_install_prefix     : $hpx_install_prefix"
    echo "hpx preset             : $hpx_preset"
    echo "mdspan_install_prefix  : $mdspan_install_prefix"
    echo "lue_source_directory   : $lue_source_directory"
    echo "lue_build_directory    : $lue_build_directory"
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

    mkdir -p $lue_build_directory
    mkdir -p $tmp_prefix
}


function preprocess_conan_install()
{
    python "$lue_source_directory/environment/script/write_conan_profile.py" $compiler $lue_source_directory/host_profile
    python "$lue_source_directory/environment/script/write_conan_profile.py" $compiler $lue_source_directory/build_profile
}


function install_hpx()
{
    if [ -d $hpx_install_prefix ]; then
        echo "→ Not installing HPX because it already exists: $hpx_install_prefix"
        return
    fi

    hpx_repository_zip="$repository_zip_prefix/v${hpx_version}.tar.gz"

    if [ ! -f $hpx_repository_zip ]; then
        wget --directory-prefix=$repository_zip_prefix https://github.com/STEllAR-GROUP/hpx/archive/refs/tags/v${hpx_version}.tar.gz
    fi

    if [ -d $hpx_source_directory ]; then
        rm -fr $hpx_source_directory
    fi

    tar -zx --directory=$(dirname $hpx_source_directory) --file $hpx_repository_zip

    mkdir $hpx_build_directory

    ln -s -f $MY_DEVENV/configuration/project/lue/CMakeUserPresets-base.json $hpx_source_directory

    if [[ ${conan_packages} ]]; then
        LUE_CONAN_PACKAGES="$conan_packages" \
            conan install $lue_source_directory \
                --profile:host=$lue_source_directory/host_profile \
                --profile:build=$lue_source_directory/build_profile \
                --settings=build_type=$build_type \
                --build=missing \
                --output-folder=$hpx_build_directory

        ln -s -f $MY_DEVENV/configuration/project/lue/CMakeUserPresets-Conan${build_type}.json $hpx_source_directory/CMakeUserPresets.json
        ln -s -f $hpx_build_directory/conan_toolchain.cmake $hpx_source_directory/conan_toolchain.cmake
        ln -s -f $hpx_build_directory/CMakePresets.json $hpx_source_directory/CMakeConanPresets.json
        ln -s -f $lue_source_directory/CMakeHPXPresets.json $hpx_source_directory
        ln -s -f $lue_source_directory/CMakePresets.json $hpx_source_directory

        # Port HPX-1.10 to CMake 3.30 (see policy CMP0167). Otherwise it won't pick up Conan's Boost module.
        sed -i'' '135 s/MODULE/CONFIG/' $hpx_source_directory/cmake/HPX_SetupBoost.cmake

        # Conan's Boost::headers target can't find the Boost headers. Sigh... Hack the path to the headers into the target.
        sed -i'' "/\${Boost_MINIMUM_VERSION} REQUIRED)/a \ \ target_include_directories(Boost::headers INTERFACE \${boost_PACKAGE_FOLDER_${build_type^^}}\/include)" $hpx_source_directory/cmake/HPX_SetupBoost.cmake
    else
        ln -s -f $lue_source_directory/CMakeHPXPresets.json $hpx_source_directory/CMakeUserPresets.json
    fi

    cmake -G "Ninja" -S $hpx_source_directory -B $hpx_build_directory --preset ${hpx_preset} $cmake_args_hpx
    cmake --build $hpx_build_directory --parallel $nr_jobs --target all
    cmake --install $hpx_build_directory --prefix $hpx_install_prefix --strip

    if [[ $OSTYPE == "msys" ]];
    then
        # On Windows, Conan's hwloc can't be used (see above), so we let HPX fetch it. The dll isn't installed though, so we do it
        # here ourselves. Sigh...
        cp $hpx_build_directory/_deps/hwloc-src/bin/* $hpx_install_prefix/bin
    fi
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
    ln -s -f $MY_DEVENV/configuration/project/lue/CMakeUserPresets-base.json $lue_source_directory

    if [[ ${conan_packages} ]]; then
        LUE_CONAN_PACKAGES="$conan_packages" \
            conan install $lue_source_directory \
                --profile:host=$lue_source_directory/host_profile \
                --profile:build=$lue_source_directory/build_profile \
                --settings=build_type=$build_type \
                --build=missing \
                --output-folder=$lue_build_directory

        ln -s -f $MY_DEVENV/configuration/project/lue/CMakeUserPresets-Conan${build_type}.json $lue_source_directory/CMakeUserPresets.json
        ln -s -f $lue_build_directory/conan_toolchain.cmake $lue_source_directory/conan_toolchain.cmake
        ln -s -f $lue_build_directory/CMakePresets.json $lue_source_directory/CMakeConanPresets.json
    else
        ln -s -f $MY_DEVENV/configuration/project/lue/CMakeUserPresets-${build_type}.json $lue_source_directory/CMakeUserPresets.json
    fi

    # Add for profiling (linux, gprof):
    # -D CMAKE_CXX_FLAGS=-pg -D CMAKE_EXE_LINKER_FLAGS=-pg -D CMAKE_SHARED_LINKER_FLAGS=-pg -D CMAKE_MODULE_LINKER_FLAGS=-pg

    cmake -G "Ninja" -S $lue_source_directory -B $lue_build_directory --preset ${lue_preset} ${cmake_args_lue}

    ln -s -f $lue_build_directory/compile_commands.json $lue_source_directory
}


parse_command_line $@
configure_builds
if [[ ${conan_packages} ]]; then
    preprocess_conan_install
fi
install_hpx
install_mdspan
configure_lue

echo -e "\n"
echo "--------------------------------------------------------------------------------------------"
echo "All ready for $build_type builds. Rerun this script before building for other build types!!!"
echo "--------------------------------------------------------------------------------------------"
