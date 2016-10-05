"""
Module with code related to generating source documentation.
"""
import os
import devenv.filesystem
import devenv.process


CPP_PROGRAMMING_LANGUAGE = "c++"
"""
Constant string for the C++ programming language.
"""

PYTHON_PROGRAMMING_LANGUAGE = "python"
"""
Constant string for the Python programming language.
"""

PROGRAMMING_LANGUAGES = [
    CPP_PROGRAMMING_LANGUAGE,
    PYTHON_PROGRAMMING_LANGUAGE
]
"""
List of programming language string constants.
"""


PROGRAMMING_LANGUAGE_BY_EXTENSION = {
    ".cc": CPP_PROGRAMMING_LANGUAGE,
    ".c": CPP_PROGRAMMING_LANGUAGE,
    ".h": CPP_PROGRAMMING_LANGUAGE,
    ".idl": CPP_PROGRAMMING_LANGUAGE,
    ".py": PYTHON_PROGRAMMING_LANGUAGE
}
"""
Dictionary mapping filename extension to programming language.
"""


def determine_programming_language(
        source_path_names):
    """
    Given the filenames in `source_path_names`, determine the programming
    language these files contain.

    Currently, the decision is based on the extension of the first regular
    file found with a known extension.
    """
    for source_path_name in source_path_names:
        if os.path.isdir(source_path_name):
            triple = os.walk(source_path_name, topdown=True).next()

            programming_language = determine_programming_language(
                # The regular files.
                [os.path.join(triple[0], name) for name in triple[2]] +
                # The directories.
                [os.path.join(triple[0], name) for name in triple[1]])
            if not programming_language is None:
                return programming_language
        else:
            extension = os.path.splitext(source_path_name)[1]
            if extension in PROGRAMMING_LANGUAGE_BY_EXTENSION:
                return PROGRAMMING_LANGUAGE_BY_EXTENSION[extension]
    return None


def generate_cpp_source_documentation(
        destination_directory_path_name,
        source_path_names):
    """
    Generate C++ source code documentation in `destination_directory_path_name`
    based on the source code in `source_path_names`.
    """
    source_path_names = devenv.filesystem.make_absolute(source_path_names)

    # Write Doxyfile.in template file.
    file_name = os.path.join(destination_directory_path_name, "Doxyfile.in")
    open(file_name, "w").write(
        "PROJECT_NAME            = ${{PROJECT_NAME}}\n"
        "INPUT                   = {}\n"
        "${{DOXYGEN_TEMPLATE}}\n".format(" ".join(source_path_names)))

    # Create a CMake project that builds the documentation.
    file_name = os.path.join(destination_directory_path_name, "CMakeLists.txt")
    open(file_name, "w").write(
        "CMAKE_MINIMUM_REQUIRED(VERSION 2.8)\n"
        "PROJECT(CPP_DOCS)\n"
        "SET(CMAKE_MODULE_PATH \"$ENV{CMAKE_MODULE_PATH}\")\n"
        "INCLUDE(Site)\n"
        "INCLUDE(DoxygenDoc)\n")

    # Configure the project, use the destination_directory_path_name as the
    # binary directory.
    generator = "Unix Makefiles"
    # generator = "MSYS Makefiles"
    command = "cmake " \
        "-G \"{}\" " \
        "\".\"".format(generator, ".")
    devenv.process.execute(command,
        working_directory=destination_directory_path_name)

    # Build the project.
    command = devenv.process.gnu_make_command(destination_directory_path_name,
        "all")
    devenv.process.execute(command)
    return os.path.normpath(os.path.join(destination_directory_path_name,
        "html", "namespaces.html"))


def generate_python_source_documentation(
        destination_directory_path_name,
        source_path_names):
    """
    Generate Python source code documentation in
    `destination_directory_path_name` based on the source code in
    `source_path_names`.

    .. note::

       Not implemented yet.
    """
    assert False, "Implement!"


def generate_source_documentation(
        destination_directory_path_name,
        source_path_names):
    """
    Generate source code documentation in `destination_directory_path_name`
    based on the source code in `source_path_names`.

    The `destination_directory_path_name` is recreated before the documentation
    is written to it.
    """
    documentation_generator_by_programming_language = {
        CPP_PROGRAMMING_LANGUAGE: generate_cpp_source_documentation,
        PYTHON_PROGRAMMING_LANGUAGE: generate_python_source_documentation
    }

    # Based on the programming language of the sources, select a function to
    # call that does the actual documentation generation.
    programming_language = determine_programming_language(source_path_names)
    documentation_generator = documentation_generator_by_programming_language[
        programming_language]

    # (Re)Make destination directory.
    devenv.filesystem.recreate_directory(destination_directory_path_name)

    return documentation_generator(destination_directory_path_name,
        source_path_names)
