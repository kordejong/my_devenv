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
set(CMAKE_C_FLAGS_DEBUG_INIT ${c_debug_flags})
set(CMAKE_CXX_FLAGS_DEBUG_INIT ${cxx_debug_flags})
