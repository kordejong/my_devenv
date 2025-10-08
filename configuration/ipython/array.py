"""
Utilities for computing array properties

Terminology is focussed on 2D arrays, but the code works with nD arrays.
"""

import math


type Shape = tuple[float, ...]
type ArrayShape = tuple[int, ...]
type CellSize = float


def discretize(shape: Shape, cell_size: CellSize) -> ArrayShape:
    """
    Return the shape of an array, discretized in cells with the size passed in
    """
    return tuple(math.floor(extent / cell_size) for extent in shape)


def array_shape_to_memory_usage(shape: ArrayShape, bytes_per_cell: int) -> int:
    """
    Return the amount of memory required by an array with the shape passed in
    """
    return math.prod(shape) * bytes_per_cell


def b_to_gib(nr_bytes: int) -> int:
    """
    Return the number of bytes passed in converted to GiB and rounded to the nearest integral value
    """
    return round(nr_bytes / 1024**3)


def shape_to_memory_usage(
    shape: Shape, cell_size: CellSize, bytes_per_cell: int
) -> int:
    """
    Return the memory usage in GiB, given an area of a certain shape and a certain number of bytes per cell
    """
    return b_to_gib(
        array_shape_to_memory_usage(discretize(shape, cell_size), bytes_per_cell)
    )


def area_to_memory_usage(area: float, cell_size: CellSize, bytes_per_cell: int) -> int:
    """
    Return the memory usage in GiB, given an area and a certain number of bytes per cell
    """
    extent = math.sqrt(area)
    shape = (extent, extent)

    return shape_to_memory_usage(shape, cell_size, bytes_per_cell)
