cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/lsb.sh
source $cwd/gransasso.sh
export CC=/opt/lsb/bin/lsbcc
export CXX=/opt/lsb/bin/lsbc++

# Some packages (at least matplotlib), search for headers in the standard
# location. This results in errors. Make sure the lsb include path is searched
# first.
export CPPFLAGS="-I/opt/lsb/include/c++"
