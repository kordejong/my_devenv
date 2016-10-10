#!/usr/bin/env python_wrapper
"""
Reconfigure project

Usage:
  reconfigure_project.py [--build_type=<bt>] [--install_prefix=<path>] [<name>]
  reconfigure_project.py -h | --help

Options:
  -h --help          Show this screen
  --build_type=<bt>  Build type
  --install_prefix=<path>  Use path as install prefix [default: /usr/local]
  name               Name of project to rebuild. If not given, it is
                     auto-detected

If no build type is passed in, the environment variable
MY_DEVENV_BUILD_TYPE is tested. If it is set, its values is used. Else
Debug is used as build type.
"""
import os
import sys
import docopt
sys.path.append(os.path.join(os.path.dirname(__file__), "..", "source"))
import devenv


@devenv.checked_call
def reconfigure_project(
        project_name,
        build_type,
        install_prefix):
    devenv.reconfigure_project(project_name, build_type, install_prefix)


if __name__ == "__main__":
    arguments = docopt.docopt(__doc__)
    name = arguments["<name>"]
    build_type = \
        arguments["--build_type"] if \
            arguments["--build_type"] is not None else \
        os.environ["MY_DEVENV_BUILD_TYPE"] if \
            "MY_DEVENV_BUILD_TYPE" in os.environ else \
        "Debug"
    install_prefix = arguments["--install_prefix"]

    if name is None:
        name = devenv.detect_project_name()

    sys.exit(reconfigure_project(name, build_type, install_prefix))
