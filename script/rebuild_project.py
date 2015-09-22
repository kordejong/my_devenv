#!/usr/bin/env python
"""
Rebuild project

Usage:
  rebuild_project.py [--build_type=<bt>] [name]
  rebuild_project.py -h | --help

Options:
  -h --help          Show this screen.
  --build_type=<bt>  Build type [default: Debug].
  name               Name of project to rebuild. If not given, it is
                     auto-detected.
"""
import sys
import docopt
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
