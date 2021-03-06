# Default configuration settings that don't depend on the machine
# and build configuration

# When overriding these settings in other CMake scripts, do not forget to
# pass the FORCE argument. Otherwise the new setting won't have an effect.

set(HPX_WITH_TOOLS ON CACHE BOOL "")

set(HPX_WITH_TESTS OFF CACHE BOOL "")
set(HPX_WITH_EXAMPLES ON CACHE BOOL "")

### set(HPX_WITH_EXAMPLES_HDF5 OFF CACHE BOOL "")
### set(HPX_WITH_EXAMPLES_OPENMP OFF CACHE BOOL "")

set(HPX_USE_CMAKE_CXX_STANDARD ON CACHE BOOL "")

# set(HPX_<MODULENAME>_WITH_COMPATIBILITY_HEADERS=OFF
set(HPX_WITH_UNWRAPPED_COMPATIBILITY OFF CACHE BOOL "")
set(HPX_WITH_INCLUSIVE_SCAN_COMPATIBILITY OFF CACHE BOOL "")
set(HPX_WITH_LOCAL_DATAFLOW_COMPATIBILITY OFF CACHE BOOL "")
set(HPX_PREPROCESSOR_WITH_COMPATIBILITY_HEADERS OFF CACHE BOOL "")

set(HPX_WITH_APEX OFF CACHE BOOL "")
set(HPX_WITH_PAPI OFF CACHE BOOL "")

# In case HPX is built with support for APEX, then these are settings
# specifically for APEX
set(APEX_WITH_OTF2 ON CACHE BOOL "")
set(APEX_WITH_PAPI ON CACHE BOOL "")
