# Stuff common for all build configurations

include(${CMAKE_CURRENT_LIST_DIR}/../linux.cmake)


# Tools
# Compiler
set(CMAKE_C_COMPILER gcc)
set(CMAKE_CXX_COMPILER g++)

include(${CMAKE_CURRENT_LIST_DIR}/../gcc.cmake)

# The environment variables are set in the script loading the modules
set(BOOST_ROOT $ENV{BOOST_ROOT} CACHE PATHNAME "")
set(HWLOC_ROOT $ENV{HWLOC_ROOT} CACHE PATHNAME "")
set(PAPI_ROOT $ENV{PAPI_ROOT} CACHE PATHNAME "")

# HPX library
include(${CMAKE_CURRENT_LIST_DIR}/../hpx.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/hpx.cmake)
