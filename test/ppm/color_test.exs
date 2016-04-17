defmodule Ppm.ColorTest do
	use ExUnit.Case
	doctest Ppm.Color

	test "Default color is black" do
		color = %Ppm.Color{}
		assert color == %Ppm.Color{r: 0, g: 0, b: 0}
	end

	test "Create color with manual values" do
		color = Ppm.Color.create(1,2,3)
		assert color == %Ppm.Color{r: 1, g: 2, b: 3}
	end

	test "Fail to create color with non-numeric values" do
		assert_raise(FunctionClauseError, fn -> Ppm.Color.create("a", 0, 0) end)
		assert_raise(FunctionClauseError, fn -> Ppm.Color.create(0, nil, 0) end)
		assert_raise(FunctionClauseError, fn -> Ppm.Color.create(0, 0, []) end)
	end

	test "Convert color to RGB binary" do
		color = Ppm.Color.create(1,2,3)
		color_binary = Ppm.Color.to_binary(color)
		assert color_binary == <<1,2,3>>
	end

	test "Binary values are modulated into the [0,255] range" do
		color = Ppm.Color.create(257,258,259)
		color_binary = Ppm.Color.to_binary(color)
		assert color_binary == <<1,2,3>>
	end

	test "Create color from three element array" do
		color = Ppm.Color.create([1,2,3])
		assert color == %Ppm.Color{r: 1, g: 2, b: 3}
	end
end
