# Target system
set(CMAKE_SYSTEM_NAME Darwin)

# Tools
set(CMAKE_C_COMPILER /opt/local/bin/clang-mp-6.0)
set(CMAKE_CXX_COMPILER /opt/local/bin/clang++-mp-6.0)

# Default flags
set(shared_flags "
    -Weverything
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

# set(triple x86_64-apple-darwin)
# set(CMAKE_C_COMPILER_TARGET ${triple})
# set(CMAKE_CXX_COMPILER_TARGET ${triple})

# set(triple arm-linux-gnueabihf)
# set(CMAKE_LIBRARY_ARCHITECTURE ${triple})
# set(CMAKE_C_COMPILER_TARGET ${triple})
# set(CMAKE_CXX_COMPILER_TARGET ${triple})

# if(CONFIG_ARM)
#     set(triple arm-none-eabi)
#     set(CMAKE_EXE_LINKER_FLAGS_INIT "--specs=nosys.specs")
# elseif(CONFIG_X86)
#     set(triple i686-pc-none-elf)
# endif()

