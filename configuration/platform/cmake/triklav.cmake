# Target platform
include(${CMAKE_CURRENT_LIST_DIR}/darwin.cmake)


# Tools
# Compiler
set(CMAKE_C_COMPILER /opt/local/bin/clang-mp-8.0)
set(CMAKE_CXX_COMPILER /opt/local/bin/clang++-mp-8.0)

set(PYBIND11_PYTHON_VERSION "3.6" CACHE STRING "")

include(${CMAKE_CURRENT_LIST_DIR}/clang.cmake)
