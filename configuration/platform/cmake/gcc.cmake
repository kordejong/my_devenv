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


# TODO Debug, RelWithDebInfo, Release, 
