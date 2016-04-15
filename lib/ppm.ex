defmodule Ppm do
	alias Ppm.Color

	@ppm_flag "P6"
	@ppm_max_color_value "255"
	@ppm_regex ~r/(?<header>P6\s+(?<width>\d+)\s+(?<height>\d+)\s+255\s)/

	def from_image_data(width, height, data) do
		case validate_image(width, height, data) do
			error ={:error, message} -> error
			{:ok} -> {:ok, construct_header(width, height) <> construct_body(data)}
		end
	end

	def to_image_data(ppm_data) do
		captures = Regex.named_captures(@ppm_regex, ppm_data)
		
		width = Map.get(captures, "width") |> String.to_integer
		height = Map.get(captures, "height") |> String.to_integer
		header_end = Map.get(captures, "header") |> String.length
		length = String.length(ppm_data) - header_end
		
		image_data = :binary.part(ppm_data, header_end, length)
		
		ppm_image = reduce_image(image_data, []) |> Enum.chunk(width)
		case validate_image(width, height, ppm_image) do
			error = {:error, message} -> error
			{:ok} -> {:ok, ppm_image}
		end
	end

	defp validate_image(width, height, data) do
		cond do
			Enum.count(data) != height -> {:error, "Missing row"}
			Enum.any?(data, fn(row) -> Enum.count(row) != width end) -> {:error, "Missing cell"}
			true -> {:ok}
		end
	end

	defp construct_header(width, height) do
		@ppm_flag <> " "
		<> Integer.to_string(width) <> " "
		<> Integer.to_string(height) <> " "
		<> @ppm_max_color_value <> "\n"
	end

	defp construct_body(data) do
		data
		|> List.flatten
		|> Enum.reduce(<<>>, fn(c = %Color{}, acc) -> acc <> Color.to_binary(c) end)
	end
	
	defp reduce_image(<<r :: size(8), g :: size(8), b :: size(8), rest :: binary>>, acc) do
		reduce_image(rest, acc ++ [Color.create(r, g, b)])
	end
	defp reduce_image(_empty, acc), do: acc
end
