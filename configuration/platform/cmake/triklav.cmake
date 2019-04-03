# Target platform
include(${CMAKE_CURRENT_LIST_DIR}/darwin.cmake)


# Tools
# Compiler
set(CMAKE_C_COMPILER /opt/local/bin/clang-mp-8.0)
set(CMAKE_CXX_COMPILER /opt/local/bin/clang++-mp-8.0)

include(${CMAKE_CURRENT_LIST_DIR}/clang.cmake)
