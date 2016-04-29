defmodule Ppm.Tuple2D do

  @moduledoc """
  A module that structures data into a 2D array of tuples for efficienct x,y
  value write access.
  """

  def create(width, height, initial \\ 0) when is_number(width) and width > 0 and is_number(height) and height > 0 do
    initial_row = construct_tuple(initial, width)
    construct_tuple(initial_row, height)
  end

  def set(tuple, x, y, value) when is_number(x) and x >= 0 and is_number(y) and y >= 0 do
    row = put_elem(elem(tuple, y), x, value)
    put_elem(tuple, y, row)
  end

  defp construct_tuple(value, length) do
    [value]
    |> Stream.cycle
    |> Enum.take(length)
    |> List.to_tuple
  end
end
