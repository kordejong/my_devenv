"""
The devenv package contains code for managing development projects.

The package contains a number of sub-packages, but the contents from these is
available directly from the devenv namespace. So, instead of writing::

   devenv.process.execute("ls")

you can write::

   devenv.execute("ls")
"""
import functools
import traceback
import devenv.process

# Users importing devenv package will get all functionality from the
# sub-modules in the devenv namespace too.
# pylint: disable-msg=W0401
from devenv.documentation import *
from devenv.filesystem import *
from devenv.package import *
from devenv.path_names import *
from devenv.project import *
from devenv.shared_libraries import *
from devenv.source_code import find_source_code


PEP8_PYTHON_CONVENTIONS = "pep8"
ARCPY_PYTHON_CONVENTIONS = "arcpy"
PYTHON_CONVENTIONS = [
    PEP8_PYTHON_CONVENTIONS,
    ARCPY_PYTHON_CONVENTIONS
]


def check_python_source(
        source_path_name,
        conventions):
    """
    .. todo::

       Document.
    """
    # TODO Check flake8, which does something similar as this function.
    # TODO See if we want to add calls to PyFlakes and McCabe.
    # 128: continuation line under-indented for visual indent
    # 501: line too long
    command = "pep8 --ignore=E501,E128 {}".format(source_path_name)
    return_code, output, errors = devenv.process.execute3(command)
    output = output.strip()
    errors = errors.strip()
    assert len(errors) == 0, errors
    if return_code != 0:
        assert len(output) != 0
        print(output)

    # W0621: Redefining name from outer scope.
    # W0702: No exception type(s) specified.
    # C0111: Missing docstring.
    # C0301: Line too long.
    # C0302: Too many lines in module.
    # R0913: Too many arguments.
    # W0212: Access to a protected member of a client class.
    # R0903: Too few public methods.
    # R0904: Too many public methods.
    # I0011: Locally disabling ...
    # E1103: Instance of ... has no ... member (but some types could not be
    #        inferred)
    # R0913: Too many arguments.
    # W0105: String statement has no effect
    common_arguments = " ".join([
        "--disable=C0111",
        "--disable=E1103",
        "--disable=I0011",
        "--disable=R0903",
        "--disable=R0904",
        "--disable=R0913",
        "--disable=W0105",
        "--disable=W0621",
        "--disable=W0702",
        "--include-ids=y",
        "--reports=n"])

    convention_specific_arguments = {
        PEP8_PYTHON_CONVENTIONS: " ".join([
            "--argument-rgx='[a-z_][a-z0-9_]{2,50}$'",
            "--variable-rgx='[a-z_][a-z0-9_]{2,50}$'",
            "--function-rgx='[a-z_][a-z0-9_]{2,60}$'",
            "--method-rgx='[a-z_][a-z0-9_]{2,60}$'"]),
        ARCPY_PYTHON_CONVENTIONS: " ".join([
            "--attr-rgx='[a-z_][a-zA-Z0-9_]{2,40}$'",
            "--argument-rgx='[a-z_][a-zA-Z0-9_]{2,40}$'",
            "--function-rgx='[A-Z_][a-zA-Z0-9_]{2,40}$'",
            "--variable-rgx='[a-z_][a-zA-Z0-9_]{2,40}$'",
            "--disable=C0301",
            "--disable=C0302",
            "--disable=R0913",
            "--disable=W0212"])
    }

    command = "pylint {} {} {}".format(common_arguments,
        convention_specific_arguments[conventions], source_path_name)
    return_code, output, errors = devenv.process.execute3(command)
    output = output.strip()
    errors = errors.strip()
    assert errors == "No config file found, using default configuration", \
        errors
    if return_code != 0:
        assert len(output) != 0
        print(output)


def check_python_sources(
        source_path_names,
        conventions):
    """
    .. todo::

       Document.

    """
    for source_path_name in source_path_names:
        check_python_source(source_path_name, conventions)


def checked_call(
        function):
    @functools.wraps(function)
    def wrapper(
            *args,
            **kwargs):
        result = 0
        try:
            result = function(*args, **kwargs)
        except:
            traceback.print_exc(file=sys.stderr)
            result = 1
        return 0 if result is None else result
    return wrapper
