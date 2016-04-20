defmodule Ppm.Tuple2D do
	def create(width, height, initial \\ 0) when is_number(width) and width > 0 and is_number(height) and height > 0 do
		(for y <- 1..height, do: (for x <- 1..width, do: initial) |> List.to_tuple) |> List.to_tuple
	end

	def set(tuple, x, y, value) when is_number(x) and x >= 0 and is_number(y) and y >= 0 do
		put_elem(tuple, y, put_elem(elem(tuple, y), x, value))
	end
end
