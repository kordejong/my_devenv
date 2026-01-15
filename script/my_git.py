#!/usr/bin/env python
from git import Repo
import git
import os.path
import sys
import docopt


doc_string = """\
Custom git commands

usage:
    {command} status <directory>...
    {command} (-h | --help)

options:
    directory          Name of directory to start in
    -h --help          Show this screen
""".format(command=os.path.basename(sys.argv[0]))


def list_uncommitted_changes(changes):
    changes_list = []

    for change in changes:
        changes_list.append("{} {}".format(change.change_type, change.a_path))

    return changes_list


def list_unstaged_changes(changes):
    changes_list = []

    for change in changes:
        changes_list.append("{} {}".format(change.change_type, change.a_path))

    return changes_list


def list_untracked_files(untracked_files):
    return untracked_files


def git_status(repository):
    if repository.is_dirty(untracked_files=True):
        print("\n\n\ncd {}".format(repository.working_tree_dir))

        # https://gitpython.readthedocs.io/en/stable/tutorial.html#obtaining-diff-information
        uncommitted_changes = repository.index.diff(repository.head.commit)
        unstaged_changes = repository.index.diff(None)
        untracked_files = repository.untracked_files

        tab = ""

        if uncommitted_changes:
            changes = list_uncommitted_changes(uncommitted_changes)
            print(
                "\n{}===== UNCOMMITTED =====\n\n{}{}".format(
                    tab, 2 * tab, ("\n" + 2 * tab).join(changes)
                )
            )

        if unstaged_changes:
            changes = list_unstaged_changes(unstaged_changes)
            print(
                "\n{}===== UNSTAGED =====\n\n{}{}".format(
                    tab, 2 * tab, ("\n" + 2 * tab).join(changes)
                )
            )

        if untracked_files:
            filenames = list_untracked_files(untracked_files)
            print(
                "\n{}===== UNTRACKED =====\n\n{}{}".format(
                    tab, 2 * tab, ("\n" + 2 * tab).join(filenames)
                )
            )


def try_open_git_repository(directory_pathname):
    try:
        repository = Repo(directory_pathname, search_parent_directories=False)
        if repository.bare:
            repository = None
    except git.InvalidGitRepositoryError:
        repository = None

    return repository


def git_status_recurse(arguments):
    directory_pathnames = arguments["<directory>"]

    print("set -e")

    for directory_pathname in directory_pathnames:
        directory_pathname = os.path.abspath(directory_pathname)

        if os.path.isdir(directory_pathname):
            for current_directory_pathname, directory_names, filenames in os.walk(
                directory_pathname
            ):
                repository = try_open_git_repository(current_directory_pathname)

                if repository is not None:
                    git_status(repository)

                    # Prevent walking into subdirectories
                    directory_names[:] = []


if __name__ == "__main__":
    arguments = docopt.docopt(doc_string)
    status = arguments["status"]

    if status:
        git_status_recurse(arguments)
