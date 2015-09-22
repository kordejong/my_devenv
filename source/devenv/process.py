"""
Module with process related functionality.
"""
import os
import shlex
import subprocess
import sys


def make_command(
        project_binary_directory_path_name):
    command = "cmake -LA {}".format(project_binary_directory_path_name)
    output = execute2(command)

    # CMAKE_MAKE_PROGRAM:FILEPATH=/usr/bin/make
    # CMAKE_MAKE_PROGRAM:FILEPATH=C:/cygwin/home/user/blah/bin/make
    # CMAKE_MAKE_PROGRAM:STRING=C:/utils/make
    # Split at first colon.
    record = [record.strip() for record in output.split("\n") if
        record.split(":")[0] == "CMAKE_MAKE_PROGRAM"]

    assert len(record) <= 1

    if len(record) == 0:
        result = "make"
    else:
        # Split at assignment.
        result = record[0].split("=")[1]

    return result


def gnu_make_command(
        project_binary_directory_path_name,
        directory_path_name,
        target_name="all"):
    """
    Format a call to make, given a directory path name and a target name.

    :param directory_path_name: Path name to directory containing Makefile.
    :param target_name: Name of target to make.

    This function takes the folowing settings read from `.devenvrc` into
    account:

    * `makeKeepGoing`
    * `makeNrJobs`
    """
    settings = {
        "makeKeepGoing": False,
        "makeNrJobs": 4
    }
    make_arguments = []
    if settings["makeKeepGoing"]:
        make_arguments.append("-k")
    make_arguments.append("-j{}".format(settings["makeNrJobs"]))
    if sys.platform == "win32":
        # Gnu make on Windows doesn't like Windows path names with backslashes.
        project_binary_directory_path_name = \
            project_binary_directory_path_name.replace("\\", "/")
        directory_path_name = directory_path_name.replace("\\", "/")

    make_command_ = make_command(project_binary_directory_path_name)

    command = "{} -C {} {} {}".format(
        make_command_,
        directory_path_name,
        " ".join(make_arguments), target_name)

    return command


def split_command(
        command):
    result = shlex.split(command)
    if sys.platform == "win32" and result[0] == "find":
        # find is also a command on Windows. It will be picked up if we don't
        # prepend the path to the find we want (Cygwin's).
        result[0] = execute2("cygpath -m \"/usr/bin/find\"").rstrip()
    return result


def execute(
        command,
        working_directory=os.getcwd()):
    """
    .. todo::

       Document.

    """
    cwd = os.getcwd()
    os.chdir(working_directory)
    result = subprocess.call(split_command(command), shell=False)
    os.chdir(cwd)

    if result != 0:
        raise RuntimeError("Error executing command:\n{}".format(command))


def execute2(
        command,
        working_directory=os.getcwd()):
    """
    .. todo::

       Document.

    """
    assert isinstance(command, str), type(command)
    cwd = os.getcwd()
    os.chdir(working_directory)
    process = subprocess.Popen(split_command(command), stdout=subprocess.PIPE,
        stderr=subprocess.PIPE, shell=False)
    output, errors = process.communicate()
    os.chdir(cwd)

    if (not process.returncode == 0):  #  or errors:
        # print "errors:", errors
        # print "output:", output
        # assert(False)
        raise RuntimeError("Error executing command:\n{}\n{}".format(command,
            errors if errors else output))
    # assert not errors, errors
    return output


def execute3(
        command,
        working_directory=os.getcwd()):
    """
    .. todo::

       Document.

    """
    cwd = os.getcwd()
    os.chdir(working_directory)
    process = subprocess.Popen(split_command(command), stdout=subprocess.PIPE,
        stderr=subprocess.PIPE, shell=False)
    output, errors = process.communicate()
    os.chdir(cwd)

    return process.returncode, output, errors
