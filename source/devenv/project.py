import os
import shutil
import sys
import distutils.spawn
import devenv.path_names


### def is_root_cmake_lists_file(
###         pathname):
###     contents = open(pathname).read()
### 
###     return "project(" in contents.lower()
### 
### 
### def project_root_directory_pathname(
###         directory_pathname):
###     assert os.path.isdir(directory_pathname)
### 
###     cmake_lists_pathname = os.path.join(directory_pathname, "CMakeLists.txt")
###     assert os.path.isfile(cmake_lists_pathname)
### 
###     if not is_root_cmake_lists_file(cmake_lists_pathname):
###         result = project_root_directory_pathname(os.path.split(
###             directory_pathname)[0])
###     else:
###         result = directory_pathname
### 
###     return os.path.split(directory_pathname)[1]


def which(
        command_name):
    return distutils.spawn.find_executable(command_name)


def ninja_installed():
    return which("ninja") is not None


def make_installed():
    return which("make") is not None


def default_cmake_generator():
    # Mmm, doesn't work as we want yet. Ninja doesn't create as many targets
    # as Make. How to build a single object file?

    # Prefer Ninja over Make
    if ninja_installed():
        result = "Ninja"
    else:
        assert make_installed()
        result = "Unix Makefiles"

    return result


def detect_project_name():
    # Find root of current project. Its name is the project name.
    ### return project_root_directory_pathname(os.getcwd())
    return os.path.basename(
        devenv.path_names.project_source_directory_path_name_from_path_name(
            os.getcwd()))


def configure_project(
        project_name,
        generator,
        build_type,
        install_prefix):
    """
    Configure the project.

    :param project_name: Name of project
    :param build_type: Build type
    :param install_prefix: Install prefix

    Configuring a project differs from reconfiguring a project in that the
    project's binary directory is not recreated first. Building a project
    after configuring it is potentially much faster when a previous build is
    present.
    """
    source_directory_path_name = \
        devenv.path_names.project_source_directory_path_name_from_project_name(
            project_name)
    binary_directory_path_name = \
        devenv.path_names.project_binary_directory_path_name(project_name,
            build_type)
    if not os.path.exists(binary_directory_path_name):
        os.makedirs(binary_directory_path_name)

    # generator = "Unix Makefiles"
    # generator = "MSYS Makefiles"

    # "-D CMAKE_VERBOSE_MAKEFILE=TRUE "
    # "-Wdev "
    # "--graphviz=%s.dot "
    # "-D CMAKE_INSTALL_PREFIX=\"{}/install\" "

    # A project may define some CMake arguments in <PROJECT>_CMAKE_ARGUMENTS.
    environment_variable_name = "{}_CMAKE_ARGUMENTS".format(
        project_name.upper())
    cmake_arguments = os.environ[environment_variable_name] if \
        environment_variable_name in os.environ else ""

    command = "cmake --verbose " \
        "-G \"{}\" " \
        "-D CMAKE_BUILD_TYPE={} " \
        "-D CMAKE_INSTALL_PREFIX={} " \
        "{} " \
        "\"{}\"".format(generator, build_type, install_prefix,
            cmake_arguments, source_directory_path_name)
    devenv.process.execute(command,
        working_directory=binary_directory_path_name)


def build_project(
        project_name,
        build_type):
    """
    Build project `project_name`.

    :param project_name: Name of project.
    :param build_type: Build type to build.

    `project_name` can be the name of a project, in which case the whole
    project is built.

    `project_name` can also be the name of a directory that is positioned
    in a project's source root directory. In that case only that sub-project
    is built.
    """
    path_name = devenv.filesystem.native_path_name(project_name)
    if (not os.path.isdir(path_name)) or (
            len(os.path.split(path_name)[0]) == 0 and not
            os.path.exists(os.path.join(path_name, "..", "CMakeLists.txt"))):
        # This branch must only be entered if project_name is the name of a
        # project.
        # The block below is meant for those cases that project_name is one of
        # the directories below the project source directory.
        # Potentially project_name is a project name, but also a name of a
        # directory. In that case we test for the existance of a CMakeLists.txt
        # file in the parent directory. If it exists, we assume project_name
        # is a project name, not a directory path name.
        source_directory_path_name = \
            devenv.path_names.project_source_directory_path_name_from_project_name(
                project_name)  # This assumes project_name is project name.
        binary_directory_path_name = \
            devenv.path_names.project_binary_directory_path_name(project_name,
                build_type)
    else:
        if not os.path.isfile(os.path.join(path_name, "CMakeLists.txt")) and \
                os.path.isfile(os.path.join(os.path.dirname(path_name),
                    "CMakeLists.txt")):
            # In case the current directory does not contain a CMakeLists.txt,
            # but the parent does, move to the parent.
            path_name = os.path.dirname(path_name)

        source_directory_path_name = path_name

        binary_directory_path_name = \
            devenv.path_names.binary_path_name_from_source_path_name(path_name,
                build_type)

    build_target(source_directory_path_name, binary_directory_path_name,
        "all", build_type)


def install_conan_dependencies(
        project_name,
        build_type):

    source_directory_pathname = \
        devenv.path_names.project_source_directory_path_name_from_project_name(
            project_name)
    binary_directory_pathname = \
        devenv.path_names.project_binary_directory_path_name(
            project_name, build_type)

    command = "conan install {} -s build_type={}".format(
        source_directory_pathname, build_type)

    devenv.process.execute(command,
        working_directory=binary_directory_pathname)


def reconfigure_project(
        project_name,
        generator,
        build_type,
        install_prefix):
    """
    Reconfigure the project.

    :param project_name: Name of project.
    :param build_type: Build type.
    :param install_prefix: Install prefix

    Reconfiguring a project differs from configuring a project in that the
    project's binary directory is recreated first. After reconfiguring a
    project, all targets must be built again.
    """
    devenv.filesystem.recreate_directory(
        devenv.path_names.project_binary_directory_path_name(project_name,
            build_type))

    if os.path.isfile(os.path.join(
            devenv.path_names.project_source_directory_path_name_from_project_name(project_name),
                "conanfile.txt")):
        install_conan_dependencies(project_name, build_type)

    configure_project(project_name, generator, build_type, install_prefix)


def build_target(
        source_path_name,
        binary_directory_path_name,
        target,
        build_type):
    # assert os.path.isfile(source_path_name), source_path_name
    # assert os.path.isdir(binary_directory_path_name), binary_directory_path_name
    binary_project_path_name = \
        devenv.path_names.project_binary_directory_path_name(
            devenv.path_names.project_name_from_path_name(
                source_path_name), build_type)
    # command = devenv.process.gnu_make_command(binary_project_path_name,
    #     binary_directory_path_name, target)
    command = "cmake --build {} --config {} --target {}".format(
        binary_directory_path_name, build_type, target)

    devenv.process.execute(command)


def rebuild_project(
        project_name,
        generator,
        build_type,
        install_prefix):
    """
    .. todo::

       Document.

    """
    reconfigure_project(project_name, generator, build_type, install_prefix)
    build_project(project_name, build_type)


def build_object(
        source_path_name,
        build_type):
    """
    .. todo::

       Document.
    """
    source_path_name = devenv.filesystem.native_path_name(source_path_name)
    assert os.path.exists(source_path_name), source_path_name
    assert os.path.isfile(source_path_name), source_path_name

    binary_path_name = devenv.path_names.binary_path_name_from_source_path_name(
        source_path_name, build_type)
    binary_directory_path_name, object_name = os.path.split(binary_path_name)
    object_name = "{}{}".format(os.path.splitext(object_name)[0],
        devenv.path_names.objects_extension())

    build_target(source_path_name, binary_directory_path_name, object_name,
        build_type)


def build_objects(
        source_directory_name,
        build_type):
    """
    .. todo::

       Document.

    """
    build_project(source_directory_name, build_type)


def run_unit_tests(
        source_directory_path_name,
        build_type):
    """
    .. todo::

       Document.

    """
    source_directory_path_name = devenv.filesystem.native_path_name(
        source_directory_path_name)
    assert os.path.exists(source_directory_path_name), \
        source_directory_path_name
    assert os.path.isdir(source_directory_path_name), \
        source_directory_path_name

    binary_directory_path_name = \
        devenv.path_names.binary_path_name_from_source_path_name(
            source_directory_path_name, build_type)
    target_name = "test"

    build_target(source_directory_path_name, binary_directory_path_name,
        target_name, build_type)


def grep_sources(
        path_name,
        pattern,
        print_directories=False,
        print_filenames=False,
        match_word=False,
        ignore_case=False,
        invert_match=False):
    assert os.path.isdir(path_name), path_name

    file_names = [
        "*.bas",  # VB
        "*.c",
        "*.cmake",
        "*.cc",
        "*.cls",  # VB
        "*.cfg",
        "*.conf",
        "*.cpp",
        "*.cxx",
        "*.css",
        "*.dot",
        "*.dox",
        "*.frm",  # VB
        "*.h",
        "*.html",
        "*.hpp",
        "*.hxx",
        "*.in",
        "*.js",
        "*.md",
        "*.py",
        "*.rst",
        "*.sh",
        "*.sty",
        "*.tex",
        "*.txt",
        "*.wiki",
        "*.xml",
        "*.xsd",
        "*.xsl",
        "*.yml",
        "bashrc",
        "bash_profile",
        "CMakeLists.txt",
        "Dockerfile",
        "Makefile",
        "testrun.epilog*",
        "testrun.prolog*",
        "Vagrantfile",
    ]
    file_names = " -or ".join(["-name \"{}\"".format(file_name) for \
        file_name in file_names])
    grep_arguments = [
        "--with-filename",
        "--extended-regexp",
        "--ignore-case" if ignore_case else "",
        "--invert-match" if invert_match else "",
        "--word-regexp" if match_word else ""
    ]
    command = "find . \( {} \) -exec grep {} \"{}\" \{{\}} \;".format(
        file_names, " ".join(grep_arguments).strip(), pattern)
    output = devenv.process.execute2(command, working_directory=path_name)

    if print_directories:
        output = "{}\n".format("\n".join(sorted(set(
            [os.path.dirname(line.split(":")[0]) for line in
                output.strip().split("\n")]
        ))))
    elif print_filenames:
        output = "{}\n".format("\n".join(sorted(set(
            [line.split(":")[0] for line in output.strip().split("\n")]
        ))))

    sys.stdout.write(output)


def grep_project(
        name,
        pattern,
        print_directories,
        print_filenames,
        match_word,
        ignore_case,
        invert_match):
    if os.path.isdir(name):
        directory_path_name = name
    else:
        directory_path_name = \
            devenv.path_names.project_source_directory_path_name_from_project_name(
                name)
        sys.stdout.write("${}\n".format(name.upper()))
        sys.stdout.flush()
    grep_sources(directory_path_name, pattern, print_directories,
        print_filenames, match_word, ignore_case, invert_match)
