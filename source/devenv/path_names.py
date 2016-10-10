"""
Module with functionality related to path names.
"""
import os
import sys
import devenv.filesystem


def filesystem_is_case_sensitive():
    return sys.platform != "win32"


def path_name_components(
        path_name):
    components = []
    while True:
        path_name, base_name = os.path.split(path_name)
        if base_name != "":
            components.append(base_name)
        else:
            if path_name != "":
                components.append(path_name)

            break
    components.reverse()
    return components


def path_names_are_equal(
        path_name1,
        path_name2):
    if not filesystem_is_case_sensitive():
        return path_name1.lower() == path_name2.lower()
    else:
        return path_name1 == path_name2


def commonprefix(
        path_names):
    """
    Return the longest path prefix that is a prefix of all paths names passed
    in.

    In case of a case-insensitive filesystem, the casing of the path names is
    synchronized first.
    """
    if not filesystem_is_case_sensitive():
        return os.path.commonprefix([path_name.lower() for path_name in
            path_names])
    else:
        return os.path.commonprefix(path_names)


def objects_extension():
    """
    Return the file extension of object files on the current platform.

    The extension returned starts with a dot.
    """
    extension_by_platform_name = {
        "win32": "obj",
        "linux2": "o",
        "darwin": "o"
    }

    # Make sure the function fails on unknown platforms.
    return ".{}".format(extension_by_platform_name[sys.platform])


def environment_variable_as_path_name(
        variable_name):
    """
    Return the value of `variable_name`, as an absolute path name.

    :param variable_name: Name of variable to look up.

    This function assumes environment variable `variable_name` is set, and
    just returns its value, as an absolute path name.
    """
    assert variable_name in os.environ, variable_name
    return os.path.abspath(devenv.filesystem.native_path_name(
        os.environ[variable_name]))


def project_source_directory_path_name_from_project_name(
        project_name):
    """
    Return the project source directory path name.

    :param project_name: Name of project.

    This function assumes environment variable *project_name*.upper() is set.
    """
    return environment_variable_as_path_name(project_name.upper())


def project_source_directory_path_name_from_path_name(
        path_name):
    """
    Return the project source directory path name.

    :param path_name: Name of path to a directory in the project's source
        directory.

    The `path_name` passed in is traversed up until no `CMakeLists.txt` is
    found. The name of the last directory containing a `CMakeList.txt` file
    is returned.
    """
    assert os.path.exists(path_name), path_name

    if not os.path.isdir(path_name):
        path_name = os.path.dirname(path_name)

    result = os.path.abspath(path_name)

    # Find the first directory containing a CMakeLists.txt file.
    while not os.path.exists(os.path.join(result, "CMakeLists.txt")):
        result = os.path.dirname(result)

    assert os.path.isfile(os.path.join(result, "CMakeLists.txt")), result

    # Find the last directory containing a CMakeLists.txt file.
    parent_directory_path_name = os.path.dirname(result)

    while os.path.exists(os.path.join(parent_directory_path_name,
            "CMakeLists.txt")):
        result = parent_directory_path_name
        parent_directory_path_name = os.path.dirname(result)

    assert os.path.isfile(os.path.join(result, "CMakeLists.txt")), result
    return result


### def project_source_directory_path_name_from_path_name(
###         path_name):
###     """
###     Return the project source directory path name.
### 
###     :param path_name: Name of path to a file in the project's source directory.
### 
###     The `path_name` passed in is traversed up until no `CMakeLists.txt` is
###     found. The name of the last directory containing a `CMakeList.txt` file
###     is returned.
###     """
###     assert os.path.exists(path_name), path_name
###     result = os.path.abspath(path_name)
### 
###     parent_directory_path_name = os.path.dirname(result)
###     while os.path.exists(os.path.join(parent_directory_path_name,
###             "CMakeLists.txt")):
###         result = parent_directory_path_name
###         parent_directory_path_name = os.path.dirname(result)
###     assert os.path.isfile(os.path.join(result, "CMakeLists.txt")), result
###     return result


### def pcrteam_extern_directory_path_name():
###     """
###     Return the path name of the pcrteam extern directory.
### 
###     The pcrteam extern directory contains the 3rd party software that is used
###     in DevEnv projects.
### 
###     This function assumes the environment variable PCRTEAM_EXTERN is set.
### 
###     Often, the path name returned is a symbolic link. If you need to compare
###     path names you may have to call os.path.realpath(...) on the result first.
###     """
###     return environment_variable_as_path_name("PCRTEAM_EXTERN")


def objects_directory_path_name():
    """
    Return the path name of the objects directory.

    The object directory contains the binary directories of all DevEnv
    projects.

    This function assumes the environment variable OBJECTS is set.
    """
    return environment_variable_as_path_name("OBJECTS")


def project_name_from_project_name(
        project_name):
    """
    Return the correctly cased project name.

    :param project_name: Name of project.

    The case of the name returned is based on the name of the project's source
    directory.
    """
    return os.path.basename(
        project_source_directory_path_name_from_project_name(
            project_name.upper()))


def project_name_from_path_name(
        path_name):
    """
    Return the correctly cased project name.

    :param path_name: Name of path to a file in the project's source directory.

    The case of the name returned is based on the name of the project's source
    directory.
    """
    return os.path.split(project_source_directory_path_name_from_path_name(
        path_name))[1]


def binary_path_name_from_source_path_name(
        source_path_name,
        build_type):
    """
    Return the equivalent binary path name of the `source_path_name` passed in.

    :param source_path_name: Name of path to file in project's source directory.
    :param build_type: Build type.

    Given some path name to a file in a project's source directory, this
    function creates a path name rooted at the project's binary directory.
    This is useful when determining the name of an object file, given the name
    of a C source file, for example. But this function works for path names of
    directories too.
    """
    source_path_name = os.path.abspath(source_path_name)

    project_name = project_name_from_path_name(source_path_name)
    project_source_directory_path_name = \
        project_source_directory_path_name_from_project_name(project_name)
    assert len(commonprefix([source_path_name,
        project_source_directory_path_name])) == len(
            project_source_directory_path_name)

    relative_source_path_name = source_path_name[
        len(project_source_directory_path_name) + 1:]

    binary_directory_path_name = os.path.join(
        project_binary_directory_path_name(project_name, build_type),
        relative_source_path_name)
    return binary_directory_path_name


def project_binary_directory_path_name(
        project_name,
        build_type):
    """
    Return the binary directory path name of a project.

    :param project_name: Name of project.
    :param build_type: Build type.
    """
    return os.path.abspath(os.path.join(objects_directory_path_name(), # "..",
        build_type, project_name_from_project_name(project_name)))
