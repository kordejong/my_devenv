# Default flags
set(shared_flags "
    -W
    -Wall
    -Wextra
")
set(c_flags "
    ${shared_flags}
")
set(cxx_flags "
    ${shared_flags}
")
string(REPLACE "\n" "" c_flags ${c_flags})
string(REPLACE "\n" "" cxx_flags ${cxx_flags})
set(CMAKE_C_FLAGS_INIT ${c_flags})
set(CMAKE_CXX_FLAGS_INIT ${cxx_flags})

# Debug flags
set(shared_debug_flags "
    -fsanitize=address
    -fsanitize=leak
    -fsanitize=undefined
    -fno-omit-frame-pointer
")
set(c_debug_flags "
    ${shared_debug_flags}
")
set(cxx_debug_flags "
    ${shared_debug_flags}
")
string(REPLACE "\n" "" c_debug_flags ${c_debug_flags})
string(REPLACE "\n" "" cxx_debug_flags ${cxx_debug_flags})
# TODO Find a way to only see messages about our own code
# set(CMAKE_C_FLAGS_DEBUG_INIT ${c_debug_flags})
# set(CMAKE_CXX_FLAGS_DEBUG_INIT ${cxx_debug_flags})

# # RelWithDebInfo flags
# # -pg Adds support for profiling
# set(shared_relwithdebinfo_flags "
# ")
# set(c_relwithdebinfo_flags "
#     ${shared_relwithdebinfo_flags}
# ")
# set(cxx_relwithdebinfo_flags "
#     ${shared_relwithdebinfo_flags}
# ")
# string(REPLACE "\n" "" c_relwithdebinfo_flags ${c_relwithdebinfo_flags})
# string(REPLACE "\n" "" cxx_relwithdebinfo_flags ${cxx_relwithdebinfo_flags})
# set(CMAKE_C_FLAGS_RELWITHDEBINFO_INIT ${c_relwithdebinfo_flags})
# set(CMAKE_CXX_FLAGS_RELWITHDEBINFO_INIT ${cxx_relwithdebinfo_flags})

# Linker
# - Use faster gold linker, except for release builds
# - -pg Adds support for profiling
set(CMAKE_EXE_LINKER_FLAGS_DEBUG_INIT "-fuse-ld=gold")
set(CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO_INIT "-fuse-ld=gold")
