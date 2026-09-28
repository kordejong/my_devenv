#!/usr/bin/env python
import getpass
import os
import sys
import time

import docopt
import psutil


def usage() -> str:
    command = os.path.basename(sys.argv[0])
    usage = f"""\
Monitor process properties over time

Usage:
    {command} <name>
    {command} --list

Options:
    name        Name of process to monitor. This can be a partial name, as long
                as matching it against running processes results in a single hit.
    -h --help   Show this screen
    --list      List process names
"""

    return usage


def processes() -> list[psutil.Process]:
    processes = []

    this_process_pid = os.getpid()

    for process in psutil.process_iter(["name", "pid", "status", "username"]):
        if (
            process.info["username"] == getpass.getuser()
            and process.info["pid"] != this_process_pid
        ):
            processes.append(process)

    return processes


def list_process_names() -> None:
    processes_ = sorted(processes(), key=lambda process: process.info["name"])

    print(
        "\n".join(
            f"{process.info['name']}, {process.info['pid']}, {process.info['username']}"
            for process in processes_
        )
    )


def find_processes_by_name(name: str) -> list[psutil.Process]:
    return [process for process in processes() if name in process.info["name"]]


def monitor_process(process: psutil.Process, *, interval: int, unit: str) -> None:
    assert unit == "GiB", unit

    bytes_to_gib_factor = 1

    if unit == "GiB":
        bytes_to_gib_factor = 1024**3

    create_time = process.create_time()

    while process.is_running():
        current_time = int(time.time())
        duration = round(current_time - create_time)

        sys.stdout.write(
            f"{duration} {process.memory_info().rss / bytes_to_gib_factor}\n"
        )
        sys.stdout.flush()

        time.sleep(interval)


def monitor_process_by_name(name: str) -> None:
    processes_ = find_processes_by_name(name)

    if not processes_:
        raise RuntimeError(f"We did not find a process named {name}")
    if len(processes_) > 1:
        raise RuntimeError(
            f"We found multiple processes named {name}: {', '.join(process.name() for process in processes_)}"
        )

    try:
        monitor_process(processes_[0], interval=5, unit="GiB")
    except psutil.NoSuchProcess:
        # Don't Panic. Process only just stopped.
        pass


if __name__ == "__main__":
    arguments = docopt.docopt(usage())

    if arguments["--list"]:
        list_process_names()
    else:
        monitor_process_by_name(arguments["<name>"])
