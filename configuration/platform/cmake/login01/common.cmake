# Stuff common for all build configurations

include(${CMAKE_CURRENT_LIST_DIR}/../linux.cmake)


# Tools
# Compiler
set(CMAKE_C_COMPILER gcc)
set(CMAKE_CXX_COMPILER g++)

# For some reason the paths to these libs don't end up in the RPATH
# of exes. Possibly because these packages have not been installed
# properly.
set(rpaths
    $ENV{ZSTD_ROOT}/lib
    $ENV{GCC_DIR}/lib64
    $ENV{BOOST_ROOT}/stage/lib
    $ENV{HWLOC_ROOT}/lib
    $ENV{GOOGLE_PERFTOOLS_ROOT}/lib
    $ENV{PAPI_ROOT}/libpfm4/lib
    $ENV{PAPI_ROOT}/src
)
set(CMAKE_BUILD_RPATH ${rpaths} CACHE STRING "")
set(CMAKE_INSTALL_RPATH ${rpaths} CACHE STRING "")

# Use same RPATH at install and build
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE CACHE BOOL "")

include(${CMAKE_CURRENT_LIST_DIR}/../gcc.cmake)

# The environment variables are set in the script loading the modules
set(GLEW_ROOT $ENV{GLEW_ROOT} CACHE PATH "")
set(HWLOC_ROOT $ENV{HWLOC_ROOT} CACHE PATH "")
set(PAPI_ROOT $ENV{PAPI_ROOT} CACHE PATH "")

# set(PYBIND11_PYTHON_VERSION "3" CACHE STRING "")

set(HDF5_PREFER_PARALLEL TRUE CACHE BOOL "")

# HPX library
include(${CMAKE_CURRENT_LIST_DIR}/../hpx.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/hpx.cmake)
