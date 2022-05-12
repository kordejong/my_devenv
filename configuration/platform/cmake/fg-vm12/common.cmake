# Stuff common for all build configurations

include(${CMAKE_CURRENT_LIST_DIR}/../windows.cmake)


# Tools
# Compiler
# set(CMAKE_C_COMPILER "Visual Studio 16 2019")
# set(CMAKE_CXX_COMPILER "Visual Studio 16 2019")

include(${CMAKE_CURRENT_LIST_DIR}/../msvc.cmake)

# set(BOOST_ROOT $ENV{HOME}/development/local/boost_1_78_0 CACHE STRING "")

# HPX library
include(${CMAKE_CURRENT_LIST_DIR}/../hpx.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/hpx.cmake)
