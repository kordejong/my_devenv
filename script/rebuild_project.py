#!/usr/bin/env python_wrapper
"""
Rebuild project

Usage:
  rebuild_project.py [--build_type=<bt>] [<name>]
  rebuild_project.py -h | --help

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


def rebuild_project(
        project_name,
        build_type):
    devenv.rebuild_project(project_name, build_type)


if __name__ == "__main__":
    arguments = docopt.docopt(__doc__)
    name = arguments["<name>"]
    build_type = arguments["--build_type"]

    if name is None:
        name = devenv.detect_project_name()

    sys.exit(rebuild_project(name, build_type))
