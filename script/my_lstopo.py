#!/usr/bin/env python
import os.path
import subprocess
import sys
import docopt


doc_string = """\
Generate visual representation of hardware

usage:
    {command} <file>
    {command} (-h | --help)

options:
    file       Pathname of output file to create. In case a file with this
               name already exists, it will be overwritten.
    -h --help  Show this screen
""".format(
        command=os.path.basename(sys.argv[0]))

def lstopo(
        output_file_pathname):

    command = "lstopo --no-io --no-factorize --force {}".format(output_file_pathname)

    subprocess.run(command.split(), check=True)


if __name__ == "__main__":
    arguments = docopt.docopt(doc_string)

    output_file_pathname = arguments["<file>"]

    lstopo(output_file_pathname)

