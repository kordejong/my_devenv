import os
import sys
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


def detect_project_name():
    # Find root of current project. Its name is the project name.
    ### return project_root_directory_pathname(os.getcwd())
    return os.path.basename(
        devenv.path_names.project_source_directory_path_name_from_path_name(
            os.getcwd()))


def configure_project(
        project_name,
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
    generator = "Unix Makefiles"
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







### """
### Module with functionality related to devenv projects.
### """
### import os
### import StringIO
### import sys
### import devenv.filesystem
### import devenv.path_names
### import devenv.process
### 
### 
### def platform():
###     """
###     .. todo::
### 
###        Document.
### 
###     """
###     objects_directory_path_name = \
###         devenv.path_names.objects_directory_path_name()
###     # platform is <compiler>_<architecture>
###     platform = os.path.basename(os.path.dirname(
###         objects_directory_path_name)).split("_")
###     assert platform[0] in ["gcc-4", "lsbcc-4", "msvs-9"], platform[0]
###     assert platform[1] in ["x86-32", "x86-64"], platform[1]
###     return tuple(platform)
### 
### 
### def lsb_platform():
###     return platform()[0].find("lsb") != -1
### 
### 
### def build_type():
###     """
###     Return the current build type.
### 
###     This function assumes environment variable BUILD_TYPE is set, and just
###     returns its value.
###     """
###     assert "BUILD_TYPE" in os.environ
###     result = os.environ["BUILD_TYPE"]
###     return result
### 
### 
### def determine_scms(
###         directory_path_name):
###     """
###     Return the source code management system used by project."
###     """
###     if os.path.exists(os.path.join(directory_path_name, ".git")):
###         return "git"
###     elif os.path.exists(os.path.join(directory_path_name, ".svn")):
###         return "svn"
###     assert False, "Unknown scms used in {}".format(directory_path_name)
### 
### 
### def project_names():
###     """
###     Return the list with lower cased project names.
### 
###     This function tests whether environment variable DEVENV_PROJECTS is set,
###     and if so, returns its value as a list of strings. If the variable is not
###     set, an empty list is returned.
###     """
###     result = []
###     if "DEVENV_PROJECTS" in os.environ:
###         result = [name.lower() for name in \
###             os.environ["DEVENV_PROJECTS"].split()]
###     return result
### 
### 
### def required_project_names(
###         names):
###     """
###     Return the list with project names that the project names in *names*
###     depend on. It is assumes that all names in *names* are listed in the
###     DEVENV_PROJECTS environment variable, and that the projects listed in
###     this variable are sorted with each subsequent project depending
###     on the previous ones.
### 
###     :param names: Names of projects.
###     """
###     # Find the index of the last project in all_project_names that is in names.
###     # We need the names of all the projects up to and including that project.
###     all_project_names = project_names()
###     assert all([name in all_project_names for name in names]), \
###         "{} not all in {}".format(names, all_project_names)
###     index = max([all_project_names.index(name) for name in names])
###     return all_project_names[:index+1]
### 
### 
### def configure_project(
###         project_name,
###         build_type):
###     """
###     Configure the project.
### 
###     :param project_name: Name of project.
###     :param build_type: Build type.
### 
###     Configuring a project differs from reconfiguring a project in that the
###     project's binary directory is not recreated first. Building a project
###     after configuring it is potentially much faster when a previous build is
###     present.
###     """
###     source_directory_path_name = \
###         devenv.path_names.project_source_directory_path_name_from_project_name(
###             project_name)
###     binary_directory_path_name = \
###         devenv.path_names.project_binary_directory_path_name(project_name,
###             build_type)
###     generator = "Unix Makefiles"
###     # generator = "MSYS Makefiles"
### 
###     # "-D CMAKE_VERBOSE_MAKEFILE=TRUE "
###     # "-Wdev "
###     # "--graphviz=%s.dot "
###     # "-D CMAKE_INSTALL_PREFIX=\"{}/install\" "
### 
###     # A project may define some CMake arguments in <PROJECT>_CMAKE_ARGUMENTS.
###     environment_variable_name = "{}_CMAKE_ARGUMENTS".format(
###         project_name.upper())
###     cmake_arguments = os.environ[environment_variable_name] if \
###         os.environ.has_key(environment_variable_name) else ""
### 
###     command = "cmake --verbose " \
###         "-G \"{}\" " \
###         "-D CMAKE_BUILD_TYPE={} " \
###         "{} " \
###         "\"{}\"".format(generator, build_type, cmake_arguments,
###             source_directory_path_name)
###     devenv.process.execute(command,
###         working_directory=binary_directory_path_name)
### 
### 
### def configure_projects(
###         project_names,
###         build_type):
###     """
###     Configure the projects.
### 
###     :param project_names: Name of projects.
###     :param build_type: Build type.
###     """
###     for project_name in project_names:
###         configure_project(project_name, build_type)


def reconfigure_project(
        project_name,
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
    configure_project(project_name, build_type, install_prefix)


### def reconfigure_projects(
###         project_names,
###         build_type):
###     """
###     Reconfigure the projects.
### 
###     :param project_names: Name of projects.
###     :param build_type: Build type.
###     """
###     for project_name in project_names:
###         reconfigure_project(project_name, build_type)


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
    command = devenv.process.gnu_make_command(binary_project_path_name,
        binary_directory_path_name, target)
    devenv.process.execute(command)


### def build_project(
###         project_name,
###         build_type):
###     """
###     Build project `project_name`.
### 
###     :param project_name: Name of project.
###     :param build_type: Build type to build.
### 
###     `project_name` can be the name of a project, in which case the whole
###     project is built.
### 
###     `project_name` can also be the name of a directory that is positioned
###     in a project's source root directory. In that case only that sub-project
###     is built.
###     """
###     path_name = devenv.filesystem.native_path_name(project_name)
###     if (not os.path.isdir(path_name)) or (
###             len(os.path.split(path_name)[0]) == 0 and not
###             os.path.exists(os.path.join(path_name, "..", "CMakeLists.txt"))):
###         # This branch must only be entered if project_name is the name of a
###         # project.
###         # The block below is meant for those cases that project_name is one of
###         # the directories below the project source directory.
###         # Potentially project_name is a project name, but also a name of a
###         # directory. In that case we test for the existance of a CMakeLists.txt
###         # file in the parent directory. If it exists, we assume project_name
###         # is a project name, not a directory path name.
###         source_directory_path_name = \
###             devenv.path_names.project_source_directory_path_name_from_project_name(
###                 project_name)  # This assumes project_name is project name.
###         binary_directory_path_name = \
###             devenv.path_names.project_binary_directory_path_name(project_name,
###                 build_type)
###     else:
###         source_directory_path_name = path_name
###         binary_directory_path_name = \
###             devenv.path_names.binary_path_name_from_source_path_name(path_name,
###                 build_type)
### 
###     build_target(source_directory_path_name, binary_directory_path_name,
###         "all", build_type)


def rebuild_project(
        project_name,
        build_type,
        install_prefix):
    """
    .. todo::

       Document.

    """
    reconfigure_project(project_name, build_type, install_prefix)
    build_project(project_name, build_type)


### def build_projects(
###         project_names,
###         build_type):
###     """
###     .. todo::
### 
###        Document.
### 
###     """
###     for project_name in project_names:
###         build_project(project_name, build_type)
### 
### 
### def rebuild_projects(
###         project_names,
###         build_type):
###     """
###     .. todo::
### 
###        Document.
### 
###     """
###     for project_name in project_names:
###         rebuild_project(project_name, build_type)
### 
### 
### def update_project_git(
###         directory_path_name):
###     command = "git pull"
###     devenv.process.execute(command, working_directory=directory_path_name)
### 
### 
### def update_project_svn(
###         directory_path_name):
###     command = "svn update"
###     devenv.process.execute(command, working_directory=directory_path_name)
### 
### 
### def update_project(
###         project_name):
###     """
###     .. todo::
### 
###        Document.
### 
###     """
###     project_source_directory_path_name = \
###         devenv.path_names.project_source_directory_path_name_from_project_name(
###             project_name)
###     scms = determine_scms(project_source_directory_path_name)
### 
###     update_project_by_scms = {
###         "git": update_project_git,
###         "svn": update_project_svn
###     }
###     update_project_by_scms[scms](project_source_directory_path_name)
### 
### 
### def update_projects(
###         project_names):
###     """
###     .. todo::
### 
###        Document.
### 
###     """
###     for project_name in project_names:
###         update_project(project_name)
### 
### 
### def status_of_project(
###         project_name,
###         write_script,
###         stream):
###     """
###     .. todo::
### 
###        Document.
### 
###     """
###     project_source_directory_path_name = \
###         devenv.path_names.project_source_directory_path_name_from_project_name(
###             project_name)
###     command = "git status"
### 
###     if not write_script:
###         status = devenv.process.execute2(command,
###             working_directory=project_source_directory_path_name)
###         status = status.split("\n")
###         assert len(status) >= 2
###         assert status[0].find("On branch ") != -1, status[0]
### 
###         nothing_to_commit_messages = [
###             "nothing to commit (working directory clean)",
###             "nothing to commit, working directory clean"]
### 
###         if not any([line in nothing_to_commit_messages for line in status]):
###             stream.write("${}\n{}".format(project_name.upper(),
###                 "\n".join(status)))
###     else:
###         command += " --porcelain"
###         status = devenv.process.execute2(command,
###             working_directory=project_source_directory_path_name)
###         if status:
###             stream.write("""\
### cd ${}
### {}\
### git commit -m""
### git pull
### git push
### """.format(project_name.upper(), status))
### 
### 
### def status_of_projects(
###         project_names,
###         write_script):
###     """
###     .. todo::
### 
###        Document.
### 
###     """
###     stream = StringIO.StringIO()
###     for project_name in project_names:
###         status_of_project(project_name, write_script, stream)
###     output = stream.getvalue()
###     stream.close()
### 
###     if output:
###         if write_script:
###             print("set -e\n")
###         print(output)
### 
### 
### def branch_name(
###         project_name):
###     variable_name = "{}_BRANCH".format(project_name.upper())
###     assert variable_name in os.environ, variable_name
###     return os.environ[variable_name]
### 
### 
### def diff_of_project(
###         project_name):
###     project_source_directory_path_name = \
###         devenv.path_names.project_source_directory_path_name_from_project_name(
###             project_name)
###     branch_name_ = branch_name(project_name)
### 
###     command = "git diff master...{}".format(branch_name_)
### 
###     status = devenv.process.execute2(command,
###         working_directory=project_source_directory_path_name)
###     if len(status) > 0:
###         status = status.strip().split("\n")
###         sys.stdout.write("${}\n{}".format(project_name.upper(),
###             "\n".join(status)))
### 
###     ### assert len(status) >= 2
###     ### assert status[0].find("# On branch ") == 0, status[0]
###     ### if not status[1] in [
###     ###         "nothing to commit (working directory clean)",
###     ###         "nothing to commit, working directory clean"]:
###     ###     stream.write("${}\n{}".format(project_name.upper(),
###     ###         "\n".join(status)))
###     ###     # if status.find("nothing to commit (working directory clean)") == -1:
### 
### 
### def diff_of_projects(
###         project_names):
###     for project_name in project_names:
###         diff_of_project(project_name)


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


### def build_objects(
###         source_path_names,
###         build_type):
###     """
###     .. todo::
### 
###        Document.
### 
###     """
###     for source_path_name in source_path_names:
###         build_object(source_path_name, build_type)


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


### def run_unit_tests(
###         source_directory_path_names,
###         build_type):
###     """
###     .. todo::
### 
###        Document.
### 
###     """
###     for source_directory_path_name in source_directory_path_names:
###         run_unit_test(source_directory_path_name, build_type)
### 
### 
### def project_file_contents(
###         project_name):
###     """
###     .. todo::
### 
###        Document.
### 
###     """
###     source_directory_path_name = \
###         devenv.path_names.project_source_directory_path_name_from_project_name(
###             project_name)
###     project_file_path_name = os.path.join(source_directory_path_name,
###         "CMakeLists.txt")
###     assert os.path.isfile(project_file_path_name), project_file_path_name
###     project_definition = open(project_file_path_name).read()
###     return project_definition


def grep_sources(
        path_name,
        pattern,
        print_filenames=False,
        match_word=False,
        ignore_case=False):
    assert os.path.isdir(path_name), path_name

    file_names = [
        "*.bas",  # VB
        "*.c",
        "*.cmake",
        "*.cc",
        "*.cls",  # VB
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
        "*.xml",
        "*.xsd",
        "*.xsl",
        "bashrc",
        "bash_profile",
        "CMakeLists.txt",
        "Makefile",
        "testrun.epilog*",
        "testrun.prolog*",
        "Vagrantfile",
    ]
    file_names = " -or ".join(["-name \"{}\"".format(file_name) for \
        file_name in file_names])
    grep_arguments = [
        "--with-filename",
        "--ignore-case" if ignore_case else "",
        "--word-regexp" if match_word else ""
    ]
    command = "find . \( {} \) -exec fgrep {} \"{}\" \{{\}} \;".format(
        file_names, " ".join(grep_arguments).strip(), pattern)
    output = devenv.process.execute2(command, working_directory=path_name)
    if print_filenames:
        output = "\n".join(set([line.split(":")[0] for line in
            output.strip().split("\n")])) + "\n"
    sys.stdout.write(output)


def grep_project(
        name,
        pattern,
        print_filenames,
        match_word,
        ignore_case):
    if os.path.isdir(name):
        directory_path_name = name
    else:
        directory_path_name = \
            devenv.path_names.project_source_directory_path_name_from_project_name(
                name)
        sys.stdout.write("${}\n".format(name.upper()))
        sys.stdout.flush()
    grep_sources(directory_path_name, pattern, print_filenames, match_word,
        ignore_case)


### def grep_projects(
###         names,
###         pattern,
###         print_filenames,
###         match_word,
###         ignore_case):
###     for name in names:
###         grep_project(name, pattern, print_filenames, match_word, ignore_case)
