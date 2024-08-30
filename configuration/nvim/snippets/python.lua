-- TODO:
-- - class
-- - member_function
-- - test_module
-- - test_case

return {
    s("script", fmt([[
#!/usr/bin/env python
"""
This module contains the implementation of the {a} script
"""
import os
import sys

import docopt


def {a}(my_argument):
    """
    Implementation of the function implementing the {a} script
    """
    print(my_argument)


def main():
    """
    Entry-point of the {a} script, which parses the command line arguments and calls the
    {a} function with the parsed values
    """
    usage = """\
{a}

Usage:
    {{command}} <my_argument>

Options:
    my_argument     TODO
    -h --help       Show this screen

{}
""".format(
        command=os.path.basename(sys.argv[0])
    )

    arguments = docopt.docopt(usage)
    my_argument = arguments["<my_argument>"]

    {a}(my_argument)


if __name__ == "__main__":
    sys.exit(main())
    ]], {
        a = i(1, "Name of script / function"),
        i(2, "Description of the script"),
    }, {
        repeat_duplicates = true,
    })),
}
