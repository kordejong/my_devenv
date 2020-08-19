# Stuff common for all build configurations

include(${CMAKE_CURRENT_LIST_DIR}/../linux.cmake)


# Tools
# Compiler
set(CMAKE_C_COMPILER gcc)
set(CMAKE_CXX_COMPILER g++)

include(${CMAKE_CURRENT_LIST_DIR}/../gcc.cmake)

# The environment variables are set in the script loading the modules
set(GLEW_ROOT $ENV{GLEW_ROOT} CACHE PATH "")
set(HWLOC_ROOT $ENV{HWLOC_ROOT} CACHE PATH "")
set(PAPI_ROOT $ENV{PAPI_ROOT} CACHE PATH "")

set(PYBIND11_PYTHON_VERSION "3" CACHE STRING "")

# HPX library
include(${CMAKE_CURRENT_LIST_DIR}/../hpx.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/hpx.cmake)
