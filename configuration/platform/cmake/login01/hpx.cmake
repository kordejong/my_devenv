# Machine-dependent configuration options that don't depend on the
# build configuration

set(HPX_WITH_MALLOC "tcmalloc" CACHE STRING "")
set(HPX_WITH_HWLOC ON CACHE BOOL "")

# set(HPX_WITH_PAPI ON CACHE BOOL "")
set(HPX_WITH_GOOGLE_PERFTOOLS ON CACHE BOOL "")

# If you are building HPX for a system with more
# than 64 processing units you must change the CMake
# variables HPX_WITH_MORE_THAN_64_THREADS (to On) and
# HPX_WITH_MAX_CPU_COUNT (to a value at least as big as the
# number of (virtual) cores on your system).
set(HPX_WITH_MORE_THAN_64_THREADS ON CACHE BOOL "")
set(HPX_WITH_MAX_CPU_COUNT "96" CACHE STRING "")

set(HPX_WITH_PARCELPORT_MPI ON CACHE BOOL "")
