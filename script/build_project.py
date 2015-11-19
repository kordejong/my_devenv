#!/usr/bin/env python_wrapper
"""
Build project

Usage:
  build_project.py [--build_type=<bt>] [<name>]
  build_project.py -h | --help

Options:
  -h --help          Show this screen.
  --build_type=<bt>  Build type.
  name               Name of project to build. If not given, it is
                     auto-detected.
"""
import os
import sys
import docopt
sys.path.append(os.path.join(os.path.dirname(__file__), "..", "source"))
import devenv


@devenv.checked_call
def build_project(
        project_name,
        build_type):
    devenv.build_project(project_name, build_type)


if __name__ == "__main__":
    arguments = docopt.docopt(__doc__)
    name = arguments["<name>"]
    build_type = \
        arguments["--build_type"] if \
            arguments["--build_type"] is not None else \
        os.environ["MY_DEVENV_BUILD_TYPE"] if \
            os.environ.has_key("MY_DEVENV_BUILD_TYPE") else \
        "Debug"

    if name is None:
        name = devenv.detect_project_name()

    sys.exit(build_project(name, build_type))
