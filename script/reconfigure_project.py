#!/usr/bin/env python_wrapper
"""
Reconfigure project

Usage:
  reconfigure_project.py [--build_type=<bt>] [<name>]
  reconfigure_project.py -h | --help

Options:
  -h --help          Show this screen.
  --build_type=<bt>  Build type [default: Debug].
  name               Name of project to rebuild. If not given, it is
                     auto-detected.
"""
import os
import sys
import docopt
sys.path.append(os.path.join(os.path.dirname(__file__), "..", "source"))
import devenv


@devenv.checked_call
def reconfigure_project(
        project_name,
        build_type):
    devenv.reconfigure_project(project_name, build_type)


if __name__ == "__main__":
    arguments = docopt.docopt(__doc__)
    name = arguments["<name>"]
    build_type = arguments["--build_type"]

    if name is None:
        name = devenv.detect_project_name()

    sys.exit(reconfigure_project(name, build_type))
