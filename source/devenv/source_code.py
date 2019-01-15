"""
Code implementing the find_source_code command
"""
from .path_names import path_name_components
import glob
import os.path


header_offset_names = ["include"]
module_offset_names = ["src"]


def is_root_directory(
        pathname):

    return len(os.path.split(pathname)[1]) == 0


def find_file(
        root_pathname,
        extensions):

    for extension in extensions:
        pathname = root_pathname + extension
        if os.path.isfile(pathname):
            return pathname

    return None


def split_pathname_at_offset(
        directory_pathname,
        offsets):

    for offset in offsets:

        head = directory_pathname

        while not os.path.split(head)[1] == offset:

            if is_root_directory(head):
                break  # Done, offset not found

            head = os.path.dirname(head)

        head, tail = os.path.split(head)

        if tail == offset:
            # Done, offset found
            return head, tail

    return None, None


def find_header(
        root_pathname):

    # Try to find the header in
    # - current directory
    # - in a parallel directory offset at offset

    extensions = [".hpp", ".h", ".hxx"]

    # See if we can find the header in the current directory
    result = find_file(root_pathname, extensions)

    if result is not None:
        return result

    head, tail = split_pathname_at_offset(
        os.path.dirname(root_pathname), module_offset_names)

    if head is None:
        return None

    # Get rid of the head prefix and slash
    offset_pathname = root_pathname[len(head)+1:]

    # Get rid of the offset and slash
    offset_pathname = offset_pathname[len(tail)+1:]

    for offset in header_offset_names:

        directory_pathname = os.path.join(head, offset)

        # Try at offset/<some_dir> (some_dir == include, probably)
        filenames = glob.glob(os.path.join(directory_pathname, "*"))
        assert(len(filenames) <= 1)

        if len(filenames) == 1 and os.path.isdir(
                os.path.join(directory_pathname, filenames[0])):
            directory_pathname = os.path.join(
                directory_pathname, filenames[0])
        meh = directory_pathname

        # Try at offset
        directory_pathname = os.path.join(directory_pathname, offset_pathname)
        result = find_file(directory_pathname, extensions)
        if result is not None:
            return result

        # Not found yet, recursively find file, return first match
        # for triple in os.walk(os.path.split(directory_pathname)[0], topdown=True):
        for triple in os.walk(meh, topdown=True):
            for directory_name in triple[1]:
                directory_pathname = os.path.join(
                    triple[0], directory_name, offset_pathname)

                result = find_file(directory_pathname, extensions)
                if result is not None:
                    return result

    return result


def find_module(
        root_pathname):

    # Try to find the module in
    # - current directory
    # - in a parallel directory offset at offset

    extensions = [".cpp", ".cc", ".c", ".cxx"]

    # Current directory
    result = find_file(root_pathname, extensions)

    if result is not None:
        return result

    head, tail = split_pathname_at_offset(
        os.path.dirname(root_pathname), header_offset_names)

    if head is None:
        return None

    # Get rid of the head prefix and slash
    offset_pathname = root_pathname[len(head)+1:]

    # Get rid of the offset and slash
    offset_pathname = offset_pathname[len(tail)+1:]

    for offset in module_offset_names:

        # Get rid of project name and slash at start of offset
        offset_pathname = offset_pathname[offset_pathname.index("/")+1:]

        # Get rid of directory parts of offset, one after the other
        components = path_name_components(offset_pathname)

        while components:
            offset_pathname = "/".join(components)
            directory_pathname = os.path.join(head, offset, offset_pathname)
            result = find_file(directory_pathname, extensions)

            if result is not None:
                break

            components = components[1:]

    return result


def find_test(
        pathname):
    print(pathname)


def find_source_code(
        pathname,
        type):

    finder_by_type = {
        "header": find_header,
        "module": find_module,
        "test": find_test,
    }

    absolute_pathname = os.path.abspath(os.path.realpath(pathname))
    root_pathname = os.path.splitext(absolute_pathname)[0]

    return finder_by_type[type](root_pathname)
