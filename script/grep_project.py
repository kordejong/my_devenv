#!/usr/bin/env python_wrapper
"""Grep project

Usage:
  grep_project.py [-i | --ignore-case]
      ([-f | --filenames] | [-d | --directories])
      [-w | --word] [--invert] <pattern> <name>
  grep_project.py -h | --help

Options:
  -h --help      Show this screen
  -f --filenames    Show only filenames containing pattern
  -d --directories  Show only directories containing files containing pattern
  -i --ignore-case  Ignore case in pattern
  -w --word      Match whole words
  --invert       Invert match
  pattern        Pattern to look for
  name           Name of project or directory to look in
"""
import os
import sys
import docopt
sys.path.append(os.path.join(os.path.dirname(__file__), "..", "source"))
import devenv


@devenv.checked_call
def grep_project(
        names,
        pattern,
        print_directories,
        print_filenames,
        match_word,
        ignore_case,
        invert_match):
    devenv.grep_project(names, pattern, print_directories, print_filenames,
        match_word, ignore_case, invert_match)


if __name__ == "__main__":
    arguments = docopt.docopt(__doc__)
    pattern = arguments["<pattern>"]
    name = arguments["<name>"]

    if name is None:
        name = devenv.detect_project_name()

    sys.exit(grep_project(name, pattern,
        print_directories=arguments["--directories"],
        print_filenames=arguments["--filenames"],
        match_word=arguments["--word"],
        ignore_case=arguments["--ignore-case"],
        invert_match=arguments["--invert"]
    ))
