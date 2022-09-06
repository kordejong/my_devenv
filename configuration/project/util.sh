function print_usage()
{
    echo -e "\
usage: $0 [-h] <build_type>

-h              Show (this) usage information.

build_type      Build type (Debug, Release)"
}


function parse_commandline()
{
    while getopts h option; do
        case $option in
            h) print_usage; exit 0;;
            *) print_usage; exit 2;;
        esac
    done
    shift $((OPTIND-1))

    if [ $# -eq 0 ]; then
        build_type="Debug"
    elif [ $# -eq 1 ]; then
        build_type=$1
    else
        print_usage
        exit 2
    fi

    export MY_DEVENV_BUILD_TYPE=$build_type
    unset build_type
}


set_prompt_for_project()
{
    local project=$1

    if [ -n "$2" ]; then
        if [ $2 == "Debug" ] || [ $2 == "Release" ]; then
            local build_type=$2
            PS1="[$project($build_type)]"
        else
            local branch=$2

            if [ -n "$3" ]; then
                local build_type=$3
                PS1="[$project-$branch($build_type)]"
            else
                PS1="[$project-$branch]"
            fi
        fi
    else
        PS1="[$project]"
    fi

    PS1="$PS1 \u@\h:\W$ "
}


function figure_out_hostname()
{
    hostname=`hostname -s 2>/dev/null`

    if [ ! "$hostname" ];
    then
        hostname=`hostname`
    fi

    if [ ! "$hostname" ];
    then
        echo "Could not figure out the hostname"
        exit 1
    fi

    hostname="$(tr [A-Z] [a-z] <<< "$hostname")"

    if [[ $hostname == int? || $hostname == tcn* ]];
    then
        hostname="snellius"
    elif [[ $hostname == uu107273 ]];
    then
        hostname="m1compiler"
    fi

    export MY_DEVENV_HOSTNAME=$hostname
    unset hostname
}


function figure_out_cmake_toolchain_file()
{
    cmake_toolchain_file=$MY_DEVENV/configuration/platform/cmake/$MY_DEVENV_HOSTNAME/$MY_DEVENV_BUILD_TYPE.cmake

    if [ ! -f $cmake_toolchain_file ]; then
        cmake_toolchain_file=$MY_DEVENV/configuration/platform/cmake/$MY_DEVENV_HOSTNAME.cmake
    fi

    if [ ! -f $cmake_toolchain_file ]; then
        echo "INFO: No CMake toolchain file found for a $MY_DEVENV_BUILD_TYPE build on $MY_DEVENV_HOSTNAME"
    fi

    export MY_DEVENV_CMAKE_TOOLCHAIN_FILE=$cmake_toolchain_file
    unset cmake_toolchain_file
}
