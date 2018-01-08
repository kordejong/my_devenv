#!/usr/bin/env python
import os
import sys
import docopt
sys.path.append(os.path.join(os.path.dirname(__file__), "..", "source"))
import devenv


doc_string = """\
Find file containing source code

usage:
  {command} (--header | --module | --test) <path>
  {command} (-h | --help)

options:
  -h --help      Show this screen
  --header       Find header file
  --module       Find module file
  --test         Find test file
  path           Pathname of current file
""".format(
        command=os.path.basename(sys.argv[0]))


@devenv.checked_call
def find_source_code(
        pathname,
        type):
    result = devenv.find_source_code(pathname, type)

    assert result is not None

    print(result)


if __name__ == "__main__":
    arguments = docopt.docopt(doc_string)

    pathname = arguments["<path>"]

    if arguments["--header"]:
        source_type="header"
    elif arguments["--module"]:
        source_type="module"
    else:
        assert arguments["--test"]
        source_type="test"

    sys.exit(find_source_code(pathname, type=source_type))
