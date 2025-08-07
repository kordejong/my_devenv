#!/usr/bin/env python
from dataclasses import dataclass
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
    "posix": [".dylib", ".so"],
}
static_library_suffixes = {
    "posix": [".a"],
}


@dataclass
class Duration:
    hours: int
    minutes: int
    seconds: int

    def __init__(self, timedelta: datetime.timedelta):
        duration_in_seconds = timedelta.total_seconds()
        days = duration_in_seconds // (24 * 3600)
        assert days == 0, days  # If needed, support days
        self.hours = int(duration_in_seconds // 3600)
        self.minutes = int((duration_in_seconds % 3600) // 60)
        self.seconds = int(duration_in_seconds % 60)

    def __str__(self) -> str:
        return f"{self.hours:02d}h:{self.minutes:02d}m:{self.seconds:02d}s"


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


def parse_ninja_log(
    path: Path,
    include_patterns: list[str],
    exclude_patterns: list[str],
) -> pd.DataFrame:
    if not path.is_file():
        raise RuntimeError(f"Ninja log {path} does not exist")

    with path.open() as file:
        lines = file.readlines()

    # header = lines[0]
    # ninja_version = header.split()[-1]
    # assert ninja_version == "v5", ninja_version

    records = {
        "output_path": [],
        "file_type": [],
        "duration": [],
    }

    # https://deepwiki.com/ninja-build/ninja/3-persistence-and-file-operations#file-format
    for line in lines[1:]:
        tokens = line.split()
        start_time = int(tokens[0])
        end_time = int(tokens[1])
        assert start_time < end_time, f"{start_time} <? {end_time}"
        duration = end_time - start_time
        output_path = Path(tokens[3])
        file_type = path_to_file_type(output_path)

        include = len(include_patterns) == 0 or any(
            pattern in str(output_path) for pattern in include_patterns
        )
        exclude = any(pattern in str(output_path) for pattern in exclude_patterns)

        if include and not exclude:
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


def duration(data_frame: pd.DataFrame, file_type: FileType) -> Duration:
    return Duration(
        datetime.timedelta(
            milliseconds=int(
                data_frame[data_frame["file_type"] == file_type].duration.sum()
            )
        )
    )


def format_markdown(
    path: Path,
    data_frame: pd.DataFrame,
    include_patterns: list[str],
    exclude_patterns: list[str],
    count: int,
) -> str:
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

    total_duration = Duration(
        datetime.timedelta(milliseconds=int(data_frame.duration.sum()))
    )

    generate_source_files_duration = duration(data_frame, file_type=FileType.SOURCE)
    build_object_files_duration = duration(data_frame, file_type=FileType.OBJECT)
    link_static_libraries_duration = duration(
        data_frame, file_type=FileType.STATIC_LIBRARY
    )
    link_shared_libraries_duration = duration(
        data_frame, file_type=FileType.SHARED_LIBRARY
    )
    link_executables_duration = duration(data_frame, file_type=FileType.EXECUTABLE)
    other_duration = duration(data_frame, file_type=FileType.OTHER)

    markdown = f"""
# Ninja log: {path}

- include patterns: {", ".join(include_patterns)}
- exclude patterns: {", ".join(exclude_patterns)}

## Durations
| Targets | Duration |
| --- | --- |
| Generate source files | {generate_source_files_duration} |
| Build object files | {build_object_files_duration} |
| Link static libraries | {link_static_libraries_duration} |
| Link shared libraries | {link_shared_libraries_duration} |
| Link executables | {link_executables_duration} |
| Other | {other_duration} |
| **All** | **{total_duration}** |

Durations listed in the tables below are in milliseconds.

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


def query_ninja_log(
    path: Path,
    include_patterns: list[str],
    exclude_patterns: list[str],
    count: int,
) -> None:
    data_frame = parse_ninja_log(
        path,
        include_patterns=include_patterns,
        exclude_patterns=exclude_patterns,
    )
    markdown = format_markdown(
        path,
        data_frame,
        include_patterns=include_patterns,
        exclude_patterns=exclude_patterns,
        count=count,
    )
    print(markdown)


def main() -> None:
    command = Path(sys.argv[0]).name
    usage = f"""\
Query Ninja log for build durations

Usage:
    {command}
        [--include=<pattern> ...] [--exclude=<pattern> ...]
        [--count=<count>] [<pathname>]

Arguments:
    pathname             Pathname of log file or directory containing log file
                         named .ninja_log (default: .ninja_log)

Options:
    -h --help            Show this screen and exit
    --include=<pattern>  Include targets whose path contains the pattern
    --exclude=<pattern>  Exclude targets whose path contains the pattern
    --count=<count>      Maximum number of targets to print, per file type
                         [default: 25]

Exclude patterns take precedence over include patterns. Targets are included
only if they are not excluded by an exclude pattern. Targets are included if
no include target has been passed in or if they are included by an include
pattern and not excluded by an exclude pattern.

Examples:
    {command}
    {command} my_ninja_log
    {command} my_build_dir
"""
    arguments = docopt.docopt(usage, sys.argv[1:])
    include_patterns = arguments["--include"]
    exclude_patterns = arguments["--exclude"]
    exclude_patterns = arguments["--exclude"]
    count = int(arguments["--count"])
    path = Path(
        arguments["<pathname>"] if arguments["<pathname>"] is not None else ".ninja_log"
    )

    if path.is_dir():
        path /= ".ninja_log"

    query_ninja_log(
        path,
        include_patterns=include_patterns,
        exclude_patterns=exclude_patterns,
        count=count,
    )


if __name__ == "__main__":
    main()
