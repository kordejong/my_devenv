#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Create pdf with plots

Usage:
  plot.py [--line=LINE_INPUT...] [--point=POINT_INPUT...] [--bar=BAR_INPUT...]
      OUTPUT
  plot.py -h | --help

Options:
  -h --help        Show this screen.
  LINE_INPUT       Input file with data column(s) for line plots.
  POINT_INPUT      Input file with data column(s) for point plots.
  BAR_INPUT        Input file with data column(s) for bar plots.
  OUTPUT           Output file.
"""
import sys
import docopt
import matplotlib.pyplot
import matplotlib.backends.backend_pdf
import numpy
import devenv


def create_line_plots(
        filenames):
    for filename in filenames:
        data = numpy.loadtxt(filename)

        if len(data.shape) == 1:
            matplotlib.pyplot.plot(range(1, data.shape[0] + 1), data)
        else:
            for i in xrange(1, data.shape[1]):
                matplotlib.pyplot.plot(data[:, 0], data[:, i])


def create_point_plots(
        filenames):
    for filename in filenames:
        data = numpy.loadtxt(filename)
        symbol = "."

        if len(data.shape) == 1:
            matplotlib.pyplot.plot(range(1, data.shape[0] + 1), data, symbol)
        else:
            for i in xrange(1, data.shape[1]):
                matplotlib.pyplot.plot(data[:, 0], data[:, i], symbol)


def create_bar_plots(
        filenames):
    bar_width = 1.0 / (len(filenames) + 1)
    colors = ["r", "b", "g"]
    offset = 0.0

    for i in xrange(len(filenames)):
        filename = filenames[i]
        data = numpy.loadtxt(filename)
        color = colors[i]

        if len(data.shape) == 0:
            matplotlib.pyplot.bar(offset, data, bar_width, color=color)
            offset += bar_width
        elif len(data.shape) == 1:
            matplotlib.pyplot.bar(numpy.arange(data.shape[0]) + offset,
                data, bar_width, color=color)
            offset += bar_width
        else:
            for i in xrange(0, data.shape[1] - 1):
                matplotlib.pyplot.bar(numpy.arange(data.shape[0]) + offset,
                    data[:, i], bar_width, color=color)
                offset += bar_width


@devenv.checked_call
def plot(
        line_input_filenames,
        point_input_filenames,
        bar_input_filenames,
        output_filename):
    pdf = matplotlib.backends.backend_pdf.PdfPages(output_filename)
    create_line_plots(line_input_filenames)
    create_point_plots(point_input_filenames)
    create_bar_plots(bar_input_filenames)

    # Multiple figures can be saved, to creat a multi-page pdf.
    pdf.savefig(matplotlib.pyplot.gcf())
    pdf.close()


if __name__ == "__main__":
    arguments = docopt.docopt(__doc__)
    line_input_filenames = arguments["--line"]
    point_input_filenames = arguments["--point"]
    bar_input_filenames = arguments["--bar"]
    output_filename = arguments["OUTPUT"]

    sys.exit(plot(line_input_filenames, point_input_filenames,
        bar_input_filenames, output_filename))
