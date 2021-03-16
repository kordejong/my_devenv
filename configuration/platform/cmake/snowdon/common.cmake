# Stuff common for all build configurations

include(${CMAKE_CURRENT_LIST_DIR}/../linux.cmake)


# Tools
# Compiler
set(CMAKE_C_COMPILER gcc-9)
set(CMAKE_CXX_COMPILER g++-9)

include(${CMAKE_CURRENT_LIST_DIR}/../gcc.cmake)

set(PYBIND11_PYTHON_VERSION "3" CACHE STRING "")

# HPX library
include(${CMAKE_CURRENT_LIST_DIR}/../hpx.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/hpx.cmake)
