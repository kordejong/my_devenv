# Default configuration settings that don't depend on the machine
# and build configuration

set(HPX_WITH_TOOLS ON CACHE BOOL "")

### set(HPX_WITH_EXAMPLES_HDF5 OFF CACHE BOOL "")
### set(HPX_WITH_EXAMPLES_OPENMP OFF CACHE BOOL "")

set(HPX_WITH_CXX17 ON CACHE BOOL "")
set(HPX_WITH_UNWRAPPED_COMPATIBILITY OFF CACHE BOOL "")
set(HPX_WITH_INCLUSIVE_SCAN_COMPATIBILITY OFF CACHE BOOL "")
set(HPX_WITH_LOCAL_DATAFLOW_COMPATIBILITY OFF CACHE BOOL "")
set(HPX_PREPROCESSOR_WITH_COMPATIBILITY_HEADERS OFF CACHE BOOL "")
# set(HPX_<MODULENAME>_WITH_COMPATIBILITY_HEADERS=OFF

# In case HPX is built with support for APEX, then these are settings
# specifically for APEX
set(HPX_WITH_APEX_TAG "develop" CACHE STRING "")
# set(HPX_WITH_APEX_TAG "support_fetch_content" CACHE STRING "")
# set(HPX_WITH_APEX_NO_UPDATE ON CACHE BOOL "")
set(APEX_WITH_OTF2 ON CACHE BOOL "")
set(APEX_WITH_PAPI ON CACHE BOOL "")
# set(APEX_WITH_ACTIVEHARMONY OFF CACHE BOOL "")

# set(HPX_WITH_VIM_YCM ON CACHE BOOL "")
