# Stuff common for all build configurations

include(${CMAKE_CURRENT_LIST_DIR}/../darwin.cmake)


# Tools
# Compiler
set(CMAKE_C_COMPILER clang)
set(CMAKE_CXX_COMPILER clang++)

include(${CMAKE_CURRENT_LIST_DIR}/../clang.cmake)

set(CMAKE_PREFIX_PATH "/opt/homebrew")

### set(PYBIND11_PYTHON_VERSION "3" CACHE STRING "")

# HPX library
include(${CMAKE_CURRENT_LIST_DIR}/../hpx.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/hpx.cmake)
