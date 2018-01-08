"""
Code implementing the find_source_code command
"""
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


def find_file_offset(
        root_pathname,
        source_offsets,
        target_offsets,
        extensions,
        skip_source_target_name,
        skip_target_target_name):

    # Source offsets is a list of potential offsets used in root_pathname
    # Target offsets is a list of potential offsets used in result pathname

    # Find common path of root_pathname and result pathname

    head, tail = split_pathname_at_offset(
        os.path.dirname(root_pathname), source_offsets)

    if head is None:
        return None

    # Get rid of the head prefix and slash
    offset_pathname = root_pathname[len(head)+1:]

    # Get rid of the offset and slash
    offset_pathname = offset_pathname[len(tail)+1:]

    if skip_source_target_name:
        # Get rid of project name and slash
        offset_pathname = offset_pathname[offset_pathname.index("/")+1:]

    for offset in target_offsets:

        directory_pathname = os.path.join(head, offset)

        if skip_target_target_name:
            filenames = glob.glob(os.path.join(directory_pathname, "*"))
            assert(len(filenames) <= 1)

            if len(filenames) == 1 and os.path.isdir(
                    os.path.join(directory_pathname, filenames[0])):
                directory_pathname = os.path.join(
                    directory_pathname, filenames[0])

        if os.path.isdir(directory_pathname):

            directory_pathname = os.path.join(
                directory_pathname, offset_pathname)

            result = find_file(directory_pathname, extensions)

            if result is not None:
                return result

    return None


def find_header(
        root_pathname):

    # Try to find the header in
    # - current directory
    # - in a parallel directory offset at offset

    extensions = [".hpp", ".h", ".hxx"]

    # Current directory
    result = find_file(root_pathname, extensions)

    if result is not None:
        return result

    # Parallel directory offset at offset
    result = find_file_offset(
        root_pathname, module_offset_names, header_offset_names, extensions,
        skip_source_target_name=False, skip_target_target_name=True)

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

    # Parallel directory offset at offset
    result = find_file_offset(
        root_pathname, header_offset_names, module_offset_names, extensions,
        skip_source_target_name=True, skip_target_target_name=False)

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
