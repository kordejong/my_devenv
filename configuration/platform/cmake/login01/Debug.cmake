# Target platform
include(${CMAKE_CURRENT_LIST_DIR}/../linux.cmake)


# Tools
# Compiler
set(CMAKE_C_COMPILER gcc)
set(CMAKE_CXX_COMPILER g++)

include(${CMAKE_CURRENT_LIST_DIR}/../gcc.cmake)


# HPX library
include(${CMAKE_CURRENT_LIST_DIR}/../hpx.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/hpx.cmake)

set(HPX_WITH_THREAD_IDLE_RATES ON CACHE BOOL "")
