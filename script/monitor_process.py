#!/usr/bin/env python
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

Options:
    name        Name of process to monitor. This can be a partial name, as long
                as matching it against running processes results in a single hit.
    -h --help   Show this screen
"""

    return usage


def find_processes_by_name(name: str) -> list[psutil.Process]:

    processes = []

    for process in psutil.process_iter(["name"]):
        if name in process.info["name"]:
            processes.append(process)

    return processes


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


if __name__ == "__main__":
    arguments = docopt.docopt(usage())

    name = arguments["<name>"]

    processes = find_processes_by_name(name)

    if not processes:
        raise RuntimeError(f"We did not find a process named {name}")
    if len(processes) > 1:
        raise RuntimeError(
            f"We found multiple processes named {name}: {', '.join(process.name() for process in processes)}"
        )

    try:
        monitor_process(processes[0], interval=5, unit="GiB")
    except psutil.NoSuchProcess:
        # Don't Panic. Process just stopped.
        pass
