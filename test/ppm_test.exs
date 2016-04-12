defmodule PpmTest do
  use ExUnit.Case
  doctest Ppm

	alias Ppm.Color

	test "simple ppm" do
		ppm_data = [[Color.create(255, 0, 0), Color.create(0, 255, 0)],
								[Color.create(0, 0, 255), Color.create(0, 0, 0)],
								[Color.create(255, 255, 255), Color.create(128, 128, 128)]]

		{:ok, ppm_string} = Ppm.from_image_data(2, 3, ppm_data)
		assert ppm_string == "P6 2 3 255\n"
		<> <<255, 0, 0>> <> <<0, 255, 0>> <> <<0, 0, 255>> <> <<0, 0, 0>> <> <<255, 255, 255>> <> <<128, 128, 128>>
	end

	test "ppm with missing cells" do
		ppm_data = [[Color.create(255, 0, 0), Color.create(0, 255, 0)],
								[Color.create(0, 0, 255)]]

		assert {:error, "Missing cell"} == Ppm.from_image_data(2, 2, ppm_data)
	end

	test "ppm with missing row" do
		ppm_data = [[Color.create(255, 0, 0), Color.create(0, 255, 0)]]

		assert {:error, "Missing row"} == Ppm.from_image_data(2, 2, ppm_data)
	end

	test "convert ppm to colors" do
		ppm_string = "P6 2 2 255\n"
		<> <<255, 0, 0>> <> <<0, 255, 0>> <> <<0, 0, 255>> <> <<0, 0, 0>>
		ppm_colors = [[Color.create(255, 0, 0), Color.create(0, 255, 0)],
								[Color.create(0, 0, 255), Color.create(0, 0, 0)]]
		assert {:ok, ppm_colors} == Ppm.to_image_data(ppm_string)
	end

	test "ppm string that is invalid" do
		ppm_string = "P6 2 2 255\n"
		<> <<255, 0, 0>> <> <<0, 255, 0>> <> <<0, 0, 255>>
		assert {:error, "Missing row"} == Ppm.to_image_data(ppm_string)
	end
end
