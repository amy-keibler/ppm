defmodule Ppm do
	alias Ppm.Color

	@ppm_flag "P6"
	@ppm_max_color_value "255"

	def from_image_data(width, height, data) do
		case validate_image(width, height, data) do
			{:error, message} -> {:error, message}
			_ -> {:ok, construct_image(width, height, data)}
		end
	end

	def to_image_data(ppm_data) do
		["P6", width_string, height_string, @ppm_max_color_value, image_data] = Regex.split(~r/[ \n]/, ppm_data)
		width = String.to_integer(width_string)
		height = String.to_integer(height_string)
		ppm_image = reduce_image(image_data, []) |> Enum.chunk(width)
		case validate_image(width, height, ppm_image) do
			{:error, message} -> {:error, message}
			_ -> {:ok, ppm_image}
		end
	end

	defp reduce_image(<<r :: size(8), g :: size(8), b :: size(8), rest :: binary>>, acc) do
		reduce_image(rest, acc ++ [Color.create(r, g, b)])
	end
	defp reduce_image(_empty, acc), do: acc

	defp validate_image(width, height, data) do
		cond do
			Enum.count(data) != height -> {:error, "Missing row"}
			Enum.reduce(data, false, fn(row, found) -> found or Enum.count(row) != width end) -> {:error, "Missing cell"}
			true -> {:ok}
		end
	end

	defp construct_image(width, height, data) do
		header = @ppm_flag <> " "
		<> Integer.to_string(width) <> " "
		<> Integer.to_string(height) <> " "
		<> @ppm_max_color_value <> "\n"
		body = Enum.reduce(data, <<>>, &reduce_columns/2)
		header <> body
	end

	defp reduce_columns(column, acc) do
		acc <> Enum.reduce(column, <<>>, fn(c = %Color{}, acc) -> acc <> Color.to_binary(c) end)
	end
end
