# Stuff common for all build configurations

include(${CMAKE_CURRENT_LIST_DIR}/../linux.cmake)


# Tools
# Compiler
set(CMAKE_C_COMPILER gcc)
set(CMAKE_CXX_COMPILER g++)

include(${CMAKE_CURRENT_LIST_DIR}/../gcc.cmake)
# Mmm, duplicate symbol errors in LUE, suddenly...
# set(CMAKE_EXE_LINKER_FLAGS_INIT "-fuse-ld=mold")  # gcc >=12.1.0
# set(CMAKE_SHARED_LINKER_FLAGS_INIT "-fuse-ld=mold")  # gcc >=12.1.0

# set(PAPI_ROOT $ENV{HOME}/development/ext CACHE STRING "")
# set(OTF2_ROOT $ENV{HOME}/development/ext/x86_64/scorep-gcc CACHE STRING "")
# # set(OTF2_LIBRARY $ENV{HOME}/development/ext CACHE PATHNAME "")
# # set(OTF2_INCLUDE_DIR

# HPX library
include(${CMAKE_CURRENT_LIST_DIR}/../hpx.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/hpx.cmake)
