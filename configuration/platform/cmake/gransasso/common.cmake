# Stuff common for all build configurations

include(${CMAKE_CURRENT_LIST_DIR}/../linux.cmake)


# Tools
# Compiler
set(CMAKE_C_COMPILER gcc-11)
set(CMAKE_CXX_COMPILER g++-11)

# Using mold with Release build triggers a bug in the linker

set(CMAKE_EXE_LINKER_FLAGS_DEBUG_INIT "-fuse-ld=mold")
set(CMAKE_MODULE_LINKER_FLAGS_DEBUG_INIT "-fuse-ld=mold")
set(CMAKE_SHARED_LINKER_FLAGS_DEBUG_INIT "-fuse-ld=mold")

set(CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO_INIT "-fuse-ld=mold")
set(CMAKE_MODULE_LINKER_FLAGS_RELWITHDEBINFO_INIT "-fuse-ld=mold")
set(CMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO_INIT "-fuse-ld=mold")

include(${CMAKE_CURRENT_LIST_DIR}/../gcc.cmake)

# set(PAPI_ROOT $ENV{HOME}/development/ext CACHE STRING "")
# set(OTF2_ROOT $ENV{HOME}/development/ext/x86_64/scorep-gcc CACHE STRING "")
# set(OTF2_LIBRARY $ENV{HOME}/development/ext CACHE PATHNAME "")
# set(OTF2_INCLUDE_DIR

# HPX library
include(${CMAKE_CURRENT_LIST_DIR}/../hpx.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/hpx.cmake)

# set(CMAKE_CXX_INCLUDE_WHAT_YOU_USE
#     "$ENV{HOME}/opt/bin/include_what_you_use" -Xiwyu;any -Xiwyu iwyu -Xiwyu args")
