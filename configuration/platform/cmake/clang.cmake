# Default flags
set(shared_flags "
    -Weverything
    -Wno-disabled-macro-expansion
    -Wno-documentation-unknown-command
    -Wno-documentation
    -Wno-padded
    -Wno-weak-vtables
")
set(c_flags "
    ${shared_flags}
")
set(cxx_flags "
    ${shared_flags}
    -Wno-c++98-compat
    -Wno-c++98-compat-pedantic
    -Wno-exit-time-destructors
    -Wno-global-constructors
")
string(REPLACE "\n" "" c_flags ${c_flags})
string(REPLACE "\n" "" cxx_flags ${cxx_flags})
set(CMAKE_C_FLAGS_INIT ${c_flags})
set(CMAKE_CXX_FLAGS_INIT ${cxx_flags})