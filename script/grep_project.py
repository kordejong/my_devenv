#!/usr/bin/env python
"""Grep project

Usage:
  grep_project.py [--ignore-case] [--filenames] [--word] <pattern> <name>
  grep_project.py -h | --help

Options:
  -h --help      Show this screen.
  --filenames    Show only filenames containing pattern.
  --ignore-case  Ignore case in pattern.
  --word         Match whole words.
  pattern        Pattern to look for.
  name           Name of project or directory to look in.
"""
import sys
import docopt
import devenv


@devenv.checked_call
def grep_project(
        names,
        pattern,
        print_filenames,
        match_word,
        ignore_case):
    devenv.grep_project(names, pattern, print_filenames, match_word,
        ignore_case)


if __name__ == "__main__":
    arguments = docopt.docopt(__doc__)
    pattern = arguments["<pattern>"]
    name = arguments["<name>"]

    if name is None:
        name = devenv.detect_project_name()

    sys.exit(grep_project(name, pattern,
        print_filenames=arguments["--filenames"],
        match_word=arguments["--word"],
        ignore_case=arguments["--ignore-case"]
    ))
