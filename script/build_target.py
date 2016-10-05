#!/usr/bin/env python_wrapper
"""
Build target.

Usage:
  build_target.py [--build_type=<bt>] (--object | --project | --test) <name>
  build_target.py -h | --help

Options:
  -h --help          Show this screen.
  --build_type=<bt>  Build type.
  --object           Build object.
  --project          Build project.
  --test             Run unit test.
  name               Name of target.
"""
import os
import sys
import docopt
sys.path.append(os.path.join(os.path.dirname(__file__), "..", "source"))
import devenv


@devenv.checked_call
def build_object(
        source_pathname,
        build_type):
    devenv.build_object(source_pathname, build_type)


@devenv.checked_call
def build_project(
        directory_pathname,
        build_type):
    devenv.build_objects(directory_pathname, build_type)


@devenv.checked_call
def run_unit_test(
        directory_pathname,
        build_type):
    devenv.build_objects(directory_pathname, build_type)
    devenv.run_unit_tests(directory_pathname, build_type)


if __name__ == "__main__":
    arguments = docopt.docopt(__doc__)
    name = arguments["<name>"]
    build_type = \
        arguments["--build_type"] if \
            arguments["--build_type"] is not None else \
        os.environ["MY_DEVENV_BUILD_TYPE"] if \
            "MY_DEVENV_BUILD_TYPE" in os.environ else \
        "Debug"

    if arguments["--object"]:
        result = build_object(name, build_type)
    elif arguments["--project"]:
        result = build_project(name, build_type)
    elif arguments["--test"]:
        result = run_unit_test(name, build_type)

    sys.exit(result)
