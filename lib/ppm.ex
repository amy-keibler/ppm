defmodule Ppm do
	alias Ppm.Color

	@ppm_flag "P6"
	@ppm_max_color_value "255"
	@ppm_regex ~r/(?<header>P6\s+(?<width>\d+)\s+(?<height>\d+)\s+255\s)/

	def from_image_data(width, height, data) do
		validate_image_and_call_on_success(width, height, data, fn -> construct_header(width, height) <> construct_body(data) end)
	end

	def to_image_data(ppm_data) do
		captures = Regex.named_captures(@ppm_regex, ppm_data)
		
		width = Map.get(captures, "width") |> String.to_integer
		height = Map.get(captures, "height") |> String.to_integer
		header_end = Map.get(captures, "header") |> String.length
		length = String.length(ppm_data) - header_end
		
		image_data = :binary.part(ppm_data, header_end, length)

		ppm_image = image_data |> :binary.bin_to_list
		|> Stream.chunk(3)
		|> Stream.map(&Color.create/1)
		|> Enum.chunk(width)

		validate_image_and_call_on_success(width, height, ppm_image, fn -> ppm_image end)
	end
	

	defp validate_image_and_call_on_success(width, height, data, success_fn) do
		cond do
			Enum.count(data) != height -> {:error, "Missing row"}
			Enum.any?(data, fn(row) -> Enum.count(row) != width end) -> {:error, "Missing cell"}
			true -> {:ok, success_fn.()}
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
		|> Enum.map(&Color.to_binary/1)
		|> :binary.list_to_bin
	end
end
