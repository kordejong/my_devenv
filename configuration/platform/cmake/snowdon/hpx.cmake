# Machine-dependent configuration options that don't depend on the
# build configuration

set(HPX_WITH_MALLOC "tcmalloc" CACHE STRING "")
set(HPX_WITH_HWLOC ON CACHE BOOL "")

set(HPX_WITH_GOOGLE_PERFTOOLS ON CACHE BOOL "")

set(HPX_WITH_NETWORKING ON CACHE BOOL "")
set(HPX_WITH_PARCELPORT_TCP ON CACHE BOOL "")
set(HPX_WITH_PARCELPORT_MPI OFF CACHE BOOL "")

# Conan Boost and HPX don't seem to play well. Error message during CMake configuration:
#     HPX inspect tool requires Boost.Regex
# For now, don't build the HPX tool.
set(HPX_WITH_TOOLS OFF CACHE BOOL "")
