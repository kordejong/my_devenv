#!/usr/bin/env python

import sys
from pathlib import Path

import docopt
import matplotlib.pyplot
import matplotlib.backends.backend_pdf
import numpy


def create_line_plots(paths: list[Path]) -> None:
    for path in paths:
        data = numpy.loadtxt(path)
        label = path.stem

        if len(data.shape) == 1:
            matplotlib.pyplot.plot(range(1, data.shape[0] + 1), data, label=label)
        elif len(data.shape) == 2:
            matplotlib.pyplot.plot(data[:, 0], data[:, 1], label=label)
        else:
            for i in range(1, data.shape[1]):
                matplotlib.pyplot.plot(data[:, 0], data[:, i], label=f"{label}-{i}")


def create_point_plots(paths: list[Path]) -> None:
    for path in paths:
        data = numpy.loadtxt(path)
        symbol = "."

        if len(data.shape) == 1:
            matplotlib.pyplot.plot(range(1, data.shape[0] + 1), data, symbol)
        else:
            for i in range(1, data.shape[1]):
                matplotlib.pyplot.plot(data[:, 0], data[:, i], symbol)


def create_bar_plots(paths: list[Path]) -> None:
    bar_width = 1.0 / (len(paths) + 1)
    colors = ["r", "b", "g"]
    offset = 0.0

    for i in range(len(paths)):
        path = paths[i]
        data = numpy.loadtxt(path)
        color = colors[i]

        if len(data.shape) == 0:
            matplotlib.pyplot.bar(offset, data, bar_width, color=color)
            offset += bar_width
        elif len(data.shape) == 1:
            matplotlib.pyplot.bar(
                numpy.arange(data.shape[0]) + offset, data, bar_width, color=color
            )
            offset += bar_width
        else:
            for i in range(0, data.shape[1] - 1):
                matplotlib.pyplot.bar(
                    numpy.arange(data.shape[0]) + offset,
                    data[:, i],
                    bar_width,
                    color=color,
                )
                offset += bar_width


def plot(
    line_input_paths: list[Path],
    point_input_paths: list[Path],
    bar_input_paths: list[Path],
    x_label: str | None,
    y_label: str | None,
    output_path: Path,
) -> None:

    matplotlib.pyplot.grid()
    create_line_plots(line_input_paths)
    create_point_plots(point_input_paths)
    create_bar_plots(bar_input_paths)
    matplotlib.pyplot.legend()

    if x_label is not None:
        matplotlib.pyplot.xlabel(x_label)

    if y_label is not None:
        matplotlib.pyplot.ylabel(y_label)

    matplotlib.pyplot.savefig(output_path)


def main() -> int:
    command = Path(sys.argv[0]).name
    usage = f"""
Create pdf with plots

Usage:
    {command} [--line=LINE_INPUT...] [--point=POINT_INPUT...] [--bar=BAR_INPUT...]
      [--x_label=<x_label>] [--y_label=<y_label>] OUTPUT
    plot.py -h | --help

Options:
    -h --help        Show this screen.
    LINE_INPUT       Input file with data column(s) for line plots.
    POINT_INPUT      Input file with data column(s) for point plots.
    BAR_INPUT        Input file with data column(s) for bar plots.
    OUTPUT           Output file.
"""
    arguments = docopt.docopt(usage)
    line_input_paths = [Path(filename) for filename in arguments["--line"]]
    point_input_paths = [Path(filename) for filename in arguments["--point"]]
    bar_input_paths = [Path(filename) for filename in arguments["--bar"]]
    output_path = Path(arguments["OUTPUT"])

    x_label = arguments["--x_label"]
    y_label = arguments["--y_label"]

    plot(
        line_input_paths,
        point_input_paths,
        bar_input_paths,
        x_label,
        y_label,
        output_path,
    )

    return 0


if __name__ == "__main__":
    sys.exit(main())
