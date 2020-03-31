# Stuff common for all build configurations

include(${CMAKE_CURRENT_LIST_DIR}/../linux.cmake)


# Tools
# Compiler
set(CMAKE_C_COMPILER gcc-7)
set(CMAKE_CXX_COMPILER g++-7)

include(${CMAKE_CURRENT_LIST_DIR}/../gcc.cmake)

set(PAPI_ROOT $ENV{HOME}/development/ext CACHE STRING "")
set(OTF2_ROOT $ENV{HOME}/development/ext/x86_64/scorep-gcc CACHE STRING "")
# set(OTF2_LIBRARY $ENV{HOME}/development/ext CACHE PATHNAME "")
# set(OTF2_INCLUDE_DIR

set(PYBIND11_PYTHON_VERSION "2.7" CACHE STRING "")

# HPX library
include(${CMAKE_CURRENT_LIST_DIR}/../hpx.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/hpx.cmake)
