### # Target system
### set(CMAKE_SYSTEM_NAME Linux)
### 
### # Tools
### set(CMAKE_C_COMPILER gcc)
### set(CMAKE_CXX_COMPILER g++)
### 
### # Default flags
### set(shared_flags "
###     -W
###     -Wall
###     -Wextra
### ")
### set(c_flags "
###     ${shared_flags}
### ")
### set(cxx_flags "
###     ${shared_flags}
### ")
### string(REPLACE "\n" "" c_flags ${c_flags})
### string(REPLACE "\n" "" cxx_flags ${cxx_flags})
### set(CMAKE_C_FLAGS_INIT ${c_flags})
### set(CMAKE_CXX_FLAGS_INIT ${cxx_flags})
### 
### 
### ### set(HPX_WITH_MALLOC "tcmalloc" CACHE STRING "")
### ### set(HPX_WITH_HWLOC ON CACHE BOOL "")
### ### set(HPX_WITH_THREAD_IDLE_RATES ON CACHE BOOL "")
### ### 
### ### # set(HPX_WITH_PAPI ON CACHE BOOL "")
### ### set(HPX_WITH_GOOGLE_PERFTOOLS ON CACHE BOOL "")
### ### 
### ### set(HPX_WITH_PARCELPORT_TCP ON CACHE BOOL "")
### ### set(HPX_WITH_PARCELPORT_MPI ON CACHE BOOL "")
### ### set(HPX_WITH_PARCELPORT_ACTION_COUNTERS ON CACHE BOOL "")
### ### 
### ### # set(HPX_WITH_TOOLS ON CACHE BOOL "")
### ### set(HPX_WITH_TESTS OFF CACHE BOOL "")
### ### set(HPX_WITH_EXAMPLES OFF CACHE BOOL "")
### ### # set(HPX_WITH_EXAMPLES_HDF5 ON CACHE BOOL "")
### ### # set(HPX_WITH_EXAMPLES_OPENMP ON CACHE BOOL "")
### ### # 
### ### # set(HPX_WITH_CXX0Y ON CACHE BOOL "")
### ### # set(HPX_WITH_UNWRAPPED_COMPATIBILITY OFF CACHE BOOL "")
### ### # set(HPX_WITH_INCLUSIVE_SCAN_COMPATIBILITY OFF CACHE BOOL "")
### ### # set(HPX_WITH_LOCAL_DATAFLOW_COMPATIBILITY OFF CACHE BOOL "")
