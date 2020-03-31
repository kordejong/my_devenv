# Stuff common for all build configurations

include(${CMAKE_CURRENT_LIST_DIR}/../linux.cmake)


# Tools
# Compiler
set(CMAKE_C_COMPILER clang-10)
set(CMAKE_CXX_COMPILER clang++-10)

include(${CMAKE_CURRENT_LIST_DIR}/../clang.cmake)

set(PYBIND11_PYTHON_VERSION "2.7" CACHE STRING "")

# HPX library
include(${CMAKE_CURRENT_LIST_DIR}/../hpx.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/hpx.cmake)
