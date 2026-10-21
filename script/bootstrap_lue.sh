#!/usr/bin/env bash
set -euo pipefail

function assert_variable_is_set() {
    local variable_name=$1

    if [ -z ${!variable_name+x} ]; then
        echo "${variable_name} is unset"
        exit 1
    fi
}

function determine_username() {
    if [ -z ${USER+x} ]; then
        local username="$USERNAME"
    else
        assert_variable_is_set "USER"
        local username="$USER"
    fi

    echo "$username"
}

function parse_command_line() {
    local usage="$(basename "$0") <hostname> <build_type>"

    if [[ $# != 2 ]]; then
        echo "$usage"
        exit 1
    fi

    hostname="$1"
    cmake_build_type="$2"
}

function print_header() {
    local title="$1"

    printf "\n[%s]\n" "$title"
}

function print_message() {
    local label="$1"
    local value="$2"

    # Get rid of newlines, nested whitespace, leading and trailing whitespace
    value=$(echo "$value" | tr -d "\n")
    value=$(echo "$value" | tr -s " ")
    value=${value%% }
    value=${value## }

    printf "    %-25s: $value\n" "$label"
}

function configure_builds() {
    cmake_args_hpx="\
        -D HPX_WITH_EXAMPLES=ON
    "
    # TODO: Configure support for tracing PER HOST!
    # # TODO: Configure apex to use jemalloc, etc(?)
    # if [[ $cmake_build_type == RelWithDebInfo ]]; then
    #     cmake_args_hpx=" \
    #         $cmake_args_hpx \
    #         -D HPX_WITH_APEX=TRUE \
    # "
    # fi
    if [[ $cmake_build_type == RelWithDebInfo ]]; then
        cmake_args_hpx=" \
            $cmake_args_hpx \
            -D HPX_WITH_TRACY=TRUE \
            -D HPX_WITH_FETCH_TRACY=TRUE \
            -D HPX_WITH_PARCEL_PROFILING=TRUE \
        "
    fi

    # TODO: Debug builds may need these:
    # HPX_WITH_PAPI
    # HPX_WITH_PARCELPORT_ACTION_COUNTERS
    # HPX_WITH_THREAD_IDLE_RATES

    cmake_args_lue="
        -D CMAKE_EXPORT_COMPILER_COMMANDS=TRUE
        -D CMAKE_VERIFY_INTERFACE_HEADER_SETS=TRUE
    "
    cmake_args_snippets="
        -D CMAKE_EXPORT_COMPILER_COMMANDS=TRUE
        -D CMAKE_VERIFY_INTERFACE_HEADER_SETS=TRUE
    "

    hpx_conan_packages=""
    lue_conan_packages=""
    # lue_preset="${hostname}_${cmake_build_type,,}"
    install_hpx=1
    configure_snippets=0

    if [[ $hostname == archlinux ]]; then
        c_compiler="gcc"
        cxx_compiler="g++"
        conan_compiler="gcc"
        # lue_conan_packages="imgui"
        hpx_preset="linux_node"
        nr_jobs=8
    elif [[ $hostname == eejit ]]; then
        c_compiler="gcc"
        cxx_compiler="g++"
        conan_compiler="gcc"
        hpx_preset="cluster"
        nr_jobs=8
        cmake_args_hpx=" \
            ${cmake_args_hpx} \
            -D HPX_WITH_FETCH_ASIO=ON \
        "
    elif [[ $hostname == hoy ]]; then
        cmake_args_lue=" \
            $cmake_args_lue \
            -D LUE_FRAMEWORK_SIGNED_INTEGRAL_ELEMENTS=std::int32_t \
            -D LUE_FRAMEWORK_UNSIGNED_INTEGRAL_ELEMENTS=std::uint8_t \
            -D LUE_FRAMEWORK_FLOATING_POINT_ELEMENTS=float \
            -D LUE_FRAMEWORK_BOOLEAN_ELEMENT=std::uint8_t \
            -D LUE_FRAMEWORK_COUNT_ELEMENT=std::int32_t \
            -D LUE_FRAMEWORK_INDEX_ELEMENT=std::int32_t \
            -D LUE_FRAMEWORK_ID_ELEMENT=std::int32_t \
        "
        c_compiler="cl"
        cxx_compiler="cl"
        conan_compiler="cl"
        hpx_conan_packages="asio boost hwloc mimalloc"
        lue_conan_packages="boost cxxopts gdal glfw imgui hdf5 nlohmann_json proj pybind11 vulkan-headers vulkan-loader"
        hpx_preset="windows_node"
        # TODO Finding Conan's jemalloc doesn't work. Sigh...
        # TODO linking against Conan's mimalloc doesn't work. Sigh...
        # TODO This is likely due to target name casing. Patch HPX CMake find logic. See also sed calls below.
        cmake_args_hpx=" \
            ${cmake_args_hpx} \
            -D HPX_WITH_MALLOC=system \
        "
        nr_jobs=10
        configure_snippets=1
    elif [[ $hostname == jureca ]]; then
        c_compiler="gcc"
        cxx_compiler="g++"
        conan_compiler="gcc"
        hpx_preset="cluster"
        install_hpx=0
        nr_jobs=8
    elif [[ $hostname == m1compiler ]]; then
        c_compiler="clang"
        cxx_compiler="clang++"
        conan_compiler="clang"
        hpx_preset="macos_node"
        cmake_args_hpx=" \
            ${cmake_args_hpx} \
            -D HPX_WITH_FETCH_ASIO=ON \
        "
        # if [[ $cmake_build_type == Debug ]]; then
        #     cmake_args_lue=" \
        #         $cmake_args_lue \
        #         -D LUE_ENABLE_ASAN=TRUE \
        #         -D LUE_ENABLE_UBSAN=TRUE \
        #     "
        # fi
        nr_jobs=4
    elif [[ $hostname == mammoth ]]; then
        c_compiler="gcc"
        cxx_compiler="g++"
        conan_compiler="gcc"
        hpx_preset="linux_node"
        nr_jobs=12
        cmake_args_hpx=" \
            ${cmake_args_hpx} \
            -D HPX_WITH_FETCH_ASIO=ON \
        "
    elif [[ $hostname == orkney ]]; then
        c_compiler="gcc"
        cxx_compiler="g++"
        conan_compiler="gcc"
        # lue_conan_packages="imgui"
        hpx_preset="linux_node"
        nr_jobs=24
        configure_snippets=1
    elif [[ $hostname == snowdon ]]; then
        c_compiler="gcc"
        cxx_compiler="g++"
        conan_compiler="gcc"
        # lue_conan_packages="imgui"
        cmake_args_lue=" \
            $cmake_args_lue \
            -D LUE_FRAMEWORK_SIGNED_INTEGRAL_ELEMENTS=std::int32_t \
            -D LUE_FRAMEWORK_UNSIGNED_INTEGRAL_ELEMENTS=std::uint8_t \
            -D LUE_FRAMEWORK_FLOATING_POINT_ELEMENTS=float \
            -D LUE_FRAMEWORK_BOOLEAN_ELEMENT=std::uint8_t \
            -D LUE_FRAMEWORK_COUNT_ELEMENT=std::int32_t \
            -D LUE_FRAMEWORK_INDEX_ELEMENT=std::int32_t \
            -D LUE_FRAMEWORK_ID_ELEMENT=std::int32_t \
        "
        hpx_preset="linux_node"
        nr_jobs=4
        configure_snippets=1
    elif [[ $hostname == spider ]]; then
        c_compiler="gcc"
        cxx_compiler="g++"
        conan_compiler="gcc"
        hpx_preset="cluster"
        nr_jobs=$SLURM_CPUS_ON_NODE
    elif [[ $hostname == velocity ]]; then
        c_compiler="gcc"
        cxx_compiler="g++"
        conan_compiler="gcc"
        hpx_preset="linux_node"
        nr_jobs=8
    else
        "Unknown hostname: $hostname"
    fi

    cmake_args_common="
        -D CMAKE_BUILD_TYPE=$cmake_build_type
        -D CMAKE_C_COMPILER=$c_compiler
        -D CMAKE_CXX_COMPILER=$cxx_compiler
        -D CMAKE_CXX_STANDARD=23
    "
    cmake_args_hpx="$cmake_args_common $cmake_args_hpx"
    cmake_args_lue="$cmake_args_common $cmake_args_lue"
    cmake_args_snippets="$cmake_args_common $cmake_args_snippets"

    install_prefix=$(realpath "$OBJECTS/../opt")/$cmake_build_type
    repository_zip_prefix=$(realpath "$OBJECTS/../repository")

    lue_preset="${hostname}"

    if [[ ${hpx_conan_packages} ]]; then
        hpx_preset="${hpx_preset}_conan"
    fi

    if [[ ${lue_conan_packages} ]]; then
        lue_preset="${lue_preset}_conan"
    fi

    hpx_preset="hpx_${cmake_build_type,,}_${hpx_preset}_configuration"
    lue_preset="${lue_preset}_${cmake_build_type,,}"

    # NOTE: Uncomment when needed
    # lue_preset="${lue_preset}_sanitize"

    tmp_prefix="/tmp/bootstrap_lue-$username"

    # NOTE: Edit when needed
    # NOTE: Comment out hpx_branch to use a released version

    hpx_repository_url="https://github.com/STEllAR-GROUP/hpx.git"
    hpx_branch="master"
    hpx_version="2.0.0"

    # hpx_version="1.11.0"
    # hpx_version="2.0.0-rc1"

    # hpx_repository_url="https://github.com/iemAnshuman/hpx.git"

    # hpx_branch="reduce_memory_caching"
    # hpx_branch="cached_allocator"
    # hpx_branch="fix/caching-allocator-tls-lookup"

    # hpx_repository_url="https://github.com/fabiancrt/hpx.git"
    # hpx_branch="investigate/7358-followup"
    # hpx_version="2.0.0"
    # cmake_args_hpx=" \
    #     $cmake_args_hpx \
    #     -D HPX_WITH_STDEXEC_TAG=04de75de5807e73a229acf047c6976575e313359
    # "

    # hpx_repository_url="https://github.com/v4xsh/hpx"
    # hpx_branch="tracy-install-export"
    # hpx_version="2.0.0"

    # hpx_repository_url="https://github.com/RohanOnKeys/hpx"
    # hpx_branch="fix-install-python-tools"
    # hpx_version="2.0.0"

    hpx_source_directory="$tmp_prefix/hpx-${hpx_version}"
    hpx_build_directory="$hpx_source_directory/build"
    hpx_install_prefix="$install_prefix/hpx"

    mdspan_install_prefix="$install_prefix/mdspan"
    lue_source_directory="$LUE"
    lue_build_directory="$OBJECTS/$cmake_build_type/lue"

    cmake_args_lue="
        $cmake_args_lue
        -D mdspan_ROOT=$mdspan_install_prefix
        -D LUE_FRAMEWORK_WITH_IMAGE_LAND=TRUE
    "
    # -D CPM_USE_LOCAL_PACKAGES=TRUE

    if [[ $install_hpx == 1 ]]; then
        cmake_args_lue="
            $cmake_args_lue
            -D HPX_ROOT=$hpx_install_prefix
        "
    fi

    if [[ $configure_snippets == 1 ]]; then
        if [ -z ${SNIPPETS+x} ]; then
            echo "\$SNIPPETS is unset"
            exit 1
        fi

        if [[ $install_hpx == 1 ]]; then
            cmake_args_snippets="
                $cmake_args_snippets
                -D HPX_ROOT=$hpx_install_prefix
            "
        fi

        snippets_source_directory="$SNIPPETS"
        snippets_build_directory="$OBJECTS/$cmake_build_type/snippets"

        if [ ! -z "${hpx_conan_packages}${lue_conan_packages}" ]; then
            snippets_preset="snippets_${conan_compiler}_${cmake_build_type,,}_conan_configuration"
        else
            snippets_preset="snippets_${c_compiler}_${cmake_build_type,,}_configuration"
        fi
    fi

    print_header "general"
    print_message "hostname" "$hostname"
    print_message "username" "$username"
    print_message "build_type" "$cmake_build_type"
    print_message "c_compiler" "$c_compiler"
    print_message "cxx_compiler" "$cxx_compiler"
    print_message "conan_compiler" "$conan_compiler"
    print_message "nr_jobs" "$nr_jobs"
    print_message "install_prefix" "$install_prefix"
    print_message "repository_zip_prefix" "$repository_zip_prefix"
    print_message "tmp_prefix" "$tmp_prefix"

    if [[ $install_hpx == 1 ]]; then
        print_header "hpx"
        print_message "hpx_conan_packages" "$hpx_conan_packages"
        print_message "cmake_args_hpx" "$cmake_args_hpx"
        print_message "hpx_repository_url" "$hpx_repository_url"
        print_message "hpx_branch" "${hpx_branch:-none: using tagged release}"
        print_message "hpx_version" "$hpx_version"
        print_message "hpx_source_directory" "$hpx_source_directory"
        print_message "hpx_build_directory" "$hpx_build_directory"
        print_message "hpx_install_prefix" "$hpx_install_prefix"
        print_message "hpx preset" "$hpx_preset"
    fi

    print_header "mdspan"
    print_message "mdspan_install_prefix" "$mdspan_install_prefix"

    print_header "lue"
    print_message "lue_conan_packages" "$lue_conan_packages"
    print_message "cmake_args_lue" "$cmake_args_lue"
    print_message "lue_source_directory" "$lue_source_directory"
    print_message "lue_build_directory" "$lue_build_directory"
    print_message "lue preset" "$lue_preset"

    if [[ $configure_snippets == 1 ]]; then
        print_header "snippets"
        print_message "cmake_args_snippets" "$cmake_args_snippets"
        print_message "snippets_source_directory" "$snippets_source_directory"
        print_message "snippets_build_directory" "$snippets_build_directory"
        print_message "snippets_preset" "$snippets_preset"
    fi

    echo
    read -p "Continue? [y/n] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[y]$ ]]; then
        exit 1
    fi

    lue_source_directory="$LUE"
    lue_build_directory="$OBJECTS/$cmake_build_type/lue"

    mkdir -p "$lue_build_directory"
    mkdir -p "$tmp_prefix"
}

function cleanup_cmake_build_directory() {
    local build_directory=$1

    if [[ ! -d $build_directory ]]; then
        echo "Build directory $build_directory does not exist..."
        exit 1
    fi

    if [ -f "$build_directory/CMakeCache.txt" ]; then
        rm "$build_directory/CMakeCache.txt"
    fi

    if [ -d "$build_directory/CMakeFiles" ]; then
        rm -r "$build_directory/CMakeFiles"
    fi
}

function preprocess_conan_install() {
    python "$lue_source_directory/environment/script/write_conan_profile.py" "$conan_compiler" "$lue_source_directory"/host_profile
    python "$lue_source_directory/environment/script/write_conan_profile.py" "$conan_compiler" "$lue_source_directory"/build_profile
}

function install_conan_packages() {
    output_directory=$1

    # Install Conan packages needed for both HPX and LUE, because Conan must be able to handle dependencies
    LUE_CONAN_PACKAGES="$hpx_conan_packages $lue_conan_packages" \
        conan install "$lue_source_directory" \
        --profile:host="$lue_source_directory"/host_profile \
        --profile:build="$lue_source_directory"/build_profile \
        --settings=build_type="$cmake_build_type" \
        --build=missing \
        --output-folder="$output_directory"
}

function install_hpx() {
    if [ -d "$hpx_install_prefix" ]; then
        echo "→ Not installing HPX because it already exists: $hpx_install_prefix"
        return
    fi

    if [ -d "$hpx_source_directory" ]; then
        rm -fr "$hpx_source_directory"
    fi

    # TODO: Pick tar file from: /p/project1/paj2600/User_EB_files and use that version

    if [ -z ${hpx_branch+x} ]; then
        # Use a released version
        echo "Using a released version of HPX: version $hpx_version"
        hpx_repository_zip="$repository_zip_prefix/v${hpx_version}.tar.gz"

        if [ ! -f "$hpx_repository_zip" ]; then
            curl --location --remote-name --output-dir "$repository_zip_prefix" https://github.com/STEllAR-GROUP/hpx/archive/refs/tags/v${hpx_version}.tar.gz
        fi

        tar -zx --directory="$(dirname "$hpx_source_directory")" --file "$hpx_repository_zip"
    else
        # Use an unreleased version
        echo "Using an unreleased version of HPX: branch $hpx_branch"
        git clone --depth 1 --branch "$hpx_branch" $hpx_repository_url "$hpx_source_directory"
    fi

    mkdir "$hpx_build_directory"

    ln -s -f $MY_DEVENV/configuration/project/hpx/CMakeUserPresets-base.json "$hpx_source_directory"

    if [[ ${hpx_conan_packages} ]]; then
        install_conan_packages $hpx_build_directory

        ln -s -f $MY_DEVENV/configuration/project/hpx/CMakeUserPresets-Conan${cmake_build_type}.json $hpx_source_directory/CMakeUserPresets.json
        ln -s -f $hpx_build_directory/CMakePresets.json $hpx_source_directory/CMakeConanPresets.json
        ln -s -f $lue_source_directory/CMakeHPXPresets.json $hpx_source_directory
        ln -s -f $lue_source_directory/CMakePresets.json $hpx_source_directory
    else
        ln -s -f $lue_source_directory/CMakeHPXPresets.json $hpx_source_directory/CMakeUserPresets.json
    fi

    cmake -G "Ninja" -S $hpx_source_directory -B $hpx_build_directory --preset ${hpx_preset} $cmake_args_hpx

    echo
    echo "Check the HPX configuration settings"
    echo
    read -p "Continue? [y/n] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[y]$ ]]; then
        exit 1
    fi

    cmake --build $hpx_build_directory --parallel $nr_jobs --target all
    cmake --install $hpx_build_directory --prefix $hpx_install_prefix --strip

    rm -fr $hpx_source_directory
}

function install_mdspan() {
    if [ -d $mdspan_install_prefix ]; then
        echo "→ Not installing mdspan because it already exists: $mdspan_install_prefix"
        return
    fi

    mdspan_repository_url="https://github.com/kokkos/mdspan.git"
    mdspan_tag="9ceface91483775a6c74d06ebf717bbb2768452f" # 0.6.0

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
        -D CMAKE_BUILD_TYPE=${cmake_build_type}
    cmake --build $mdspan_build_directory --parallel $nr_jobs --target all
    cmake --install $mdspan_build_directory --prefix $mdspan_install_prefix --strip
    rm -fr $mdspan_source_directory
}

function configure_lue() {
    ln -s -f $MY_DEVENV/configuration/project/lue/CMakeUserPresets-base.json $lue_source_directory

    if [[ ${lue_conan_packages} ]]; then
        install_conan_packages $lue_build_directory

        ln -s -f $MY_DEVENV/configuration/project/lue/CMakeUserPresets-Conan${cmake_build_type}.json $lue_source_directory/CMakeUserPresets.json
        ln -s -f $lue_build_directory/CMakePresets.json $lue_source_directory/CMakeConanPresets.json
    else
        ln -s -f $MY_DEVENV/configuration/project/lue/CMakeUserPresets-${cmake_build_type}.json $lue_source_directory/CMakeUserPresets.json
    fi

    # Add for profiling (linux, gprof):
    # -D CMAKE_CXX_FLAGS=-pg -D CMAKE_EXE_LINKER_FLAGS=-pg -D CMAKE_SHARED_LINKER_FLAGS=-pg -D CMAKE_MODULE_LINKER_FLAGS=-pg

    cleanup_cmake_build_directory "$lue_build_directory"

    cmake -G "Ninja" -S $lue_source_directory -B $lue_build_directory --preset ${lue_preset} ${cmake_args_lue}

    ln -s -f $lue_build_directory/compile_commands.json $lue_source_directory
}

function configure_snippets() {
    if [ ! -z "${hpx_conan_packages}${lue_conan_packages}" ]; then
        install_conan_packages $snippets_build_directory

        ln -s -f $MY_DEVENV/configuration/project/snippets/CMakeUserPresets-base.json $snippets_source_directory
        ln -s -f $MY_DEVENV/configuration/project/snippets/CMakeUserPresets-Conan${cmake_build_type}.json $snippets_source_directory/CMakeUserPresets.json
        ln -s -f $snippets_build_directory/CMakePresets.json $snippets_source_directory/CMakeConanPresets.json
    fi

    cleanup_cmake_build_directory "$snippets_build_directory"

    cmake -G "Ninja" -S $snippets_source_directory -B $snippets_build_directory --preset ${snippets_preset} ${cmake_args_snippets}

    ln -s -f $snippets_build_directory/compile_commands.json $snippets_source_directory
}

assert_variable_is_set MY_DEVENV
assert_variable_is_set LUE
assert_variable_is_set OBJECTS
username="$(determine_username)"

parse_command_line $@
configure_builds
if [ ! -z "${hpx_conan_packages}${lue_conan_packages}" ]; then
    preprocess_conan_install
fi
if [[ $install_hpx == 1 ]]; then
    install_hpx
fi
install_mdspan
configure_lue
if [[ $configure_snippets == 1 ]]; then
    configure_snippets
fi

echo -e "\n"
echo "--------------------------------------------------------------------------------------------"
echo "All ready for $cmake_build_type builds. Rerun this script before building for other build types!!!"
echo "--------------------------------------------------------------------------------------------"
