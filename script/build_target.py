#!/usr/bin/env python
"""
Build target.

Usage:
  build_target.py [--build_type=<bt>] (--object | --project | --test) <name>
  build_target.py -h | --help

Options:
  -h --help          Show this screen.
  --build_type=<bt>  Build type [default: Debug].
  --object           Build object.
  --project          Build project.
  --test             Run unit test.
  name               Name of target.
"""
import sys
import docopt
import devenv


@devenv.checked_call
def build_object(
        source_pathname,
        build_type):
    return devenv.build_object(source_pathname, build_type)


@devenv.checked_call
def build_project(
        directory_pathname,
        build_type):
    return devenv.build_objects(directory_pathname, build_type)


@devenv.checked_call
def run_unit_test(
        directory_pathname,
        build_type):
    return devenv.run_unit_tests(directory_pathname, build_type)


if __name__ == "__main__":
    arguments = docopt.docopt(__doc__)
    name = arguments["<name>"]
    build_type = arguments["--build_type"]

    if arguments["--object"]:
        result = build_object(name, build_type)
    elif arguments["--project"]:
        result = build_project(name, build_type)
    elif arguments["--test"]:
        result = run_unit_test(name, build_type)

    sys.exit(result)
