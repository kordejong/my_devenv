#!/usr/bin/env python
import datetime
import enum
import os
from pathlib import Path
import sys

import docopt
import pandas as pd


class FileType(enum.Enum):
    OBJECT = enum.auto()
    SHARED_LIBRARY = enum.auto()
    SOURCE = enum.auto()
    STATIC_LIBRARY = enum.auto()
    EXECUTABLE = enum.auto()
    CMAKE = enum.auto()
    NINJA = enum.auto()
    OTHER = enum.auto()
    UNKNOWN = enum.auto()


object_suffixes = {
    "posix": [".o"],
}
source_suffixes = {
    "posix": [".cpp", ".hpp"],
}
shared_library_suffixes = {
    "posix": [".so"],
}
static_library_suffixes = {
    "posix": [".a"],
}


def path_to_file_type(path: Path) -> FileType:
    suffixes = path.suffixes
    file_type = FileType.UNKNOWN

    os_name = os.name

    # Order matters!
    if not suffixes:
        if "CMakeFiles" in path.parts:
            file_type = FileType.OTHER
        else:
            file_type = FileType.EXECUTABLE
    elif any(suffix in object_suffixes[os_name] for suffix in suffixes):
        file_type = FileType.OBJECT
    elif any(suffix in source_suffixes[os_name] for suffix in suffixes):
        file_type = FileType.SOURCE
    elif any(suffix in static_library_suffixes[os_name] for suffix in suffixes):
        file_type = FileType.STATIC_LIBRARY
    elif any(suffix in shared_library_suffixes[os_name] for suffix in suffixes):
        file_type = FileType.SHARED_LIBRARY
    elif any(suffix in [".ninja"] for suffix in suffixes):
        file_type = FileType.NINJA
    elif "CMakeFiles" in path.parts:
        file_type = FileType.CMAKE

    assert not file_type == FileType.UNKNOWN, path

    return file_type


def parse_ninja_log(path: Path) -> pd.DataFrame:
    if not path.is_file():
        raise RuntimeError(f"Ninja log {path} does not exist")

    with path.open() as file:
        lines = file.readlines()

    header = lines[0]
    ninja_version = header.split()[-1]
    assert ninja_version == "v5", ninja_version

    records = {
        "output_path": [],
        "file_type": [],
        "duration": [],
    }

    # https://deepwiki.com/ninja-build/ninja/3-persistence-and-file-operations#file-format
    for line in lines[1:]:
        tokens = line.split()
        start_time = datetime.datetime.fromtimestamp(int(tokens[0]))
        end_time = datetime.datetime.fromtimestamp(int(tokens[1]))
        assert start_time < end_time, f"{start_time} <? {end_time}"
        duration = end_time - start_time
        output_path = Path(tokens[3])

        file_type = path_to_file_type(output_path)

        records["output_path"].append(output_path)
        records["file_type"].append(file_type)
        records["duration"].append(duration)

    return pd.DataFrame(records)


def slowest_builds(
    data_frame: pd.DataFrame, file_type: FileType, count: int
) -> pd.DataFrame:
    object_files = data_frame[data_frame["file_type"] == file_type][
        ["output_path", "duration"]
    ]
    object_files = object_files.sort_values("duration", ascending=False)

    return object_files.iloc[0:count]


def format_markdown(path: Path, data_frame: pd.DataFrame) -> str:
    count = 25
    source_files = slowest_builds(data_frame, file_type=FileType.SOURCE, count=count)
    object_files = slowest_builds(data_frame, file_type=FileType.OBJECT, count=count)
    static_libraries = slowest_builds(
        data_frame, file_type=FileType.STATIC_LIBRARY, count=count
    )
    shared_libraries = slowest_builds(
        data_frame, file_type=FileType.SHARED_LIBRARY, count=count
    )
    executables = slowest_builds(data_frame, file_type=FileType.EXECUTABLE, count=count)
    others = slowest_builds(data_frame, file_type=FileType.OTHER, count=count)

    markdown = f"""
# Ninja log: {path}

## Durations

### Generate

#### Source files
{source_files.to_markdown(index=False)}

### Build

#### Object files
{object_files.to_markdown(index=False)}

### Link

#### Static libraries
{static_libraries.to_markdown(index=False)}

#### Shared libraries
{shared_libraries.to_markdown(index=False)}

#### Executables
{executables.to_markdown(index=False)}

### Other
{others.to_markdown(index=False)}
"""

    return markdown


def query_ninja_log(path: Path) -> None:
    data_frame = parse_ninja_log(path)
    markdown = format_markdown(path, data_frame)
    print(markdown)


def main() -> None:
    command = Path(sys.argv[0]).name
    usage = f"""\
Query Ninja log for build durations

Usage:
    {command} [<pathname>]

Arguments:
    pathname           Pathname of log file or directory containing log file
                       named .ninja_log (default: .ninja_log)

Options:
    -h --help          Show this screen and exit

Examples:
    {command}
    {command} my_ninja_log
    {command} my_build_dir
"""
    arguments = docopt.docopt(usage, sys.argv[1:])
    path = Path(
        arguments["<pathname>"] if arguments["<pathname>"] is not None else ".ninja_log"
    )

    if path.is_dir():
        path /= ".ninja_log"

    query_ninja_log(path)


if __name__ == "__main__":
    main()
