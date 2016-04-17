defmodule Ppm.Color do
	defstruct r: 0, g: 0, b: 0

	def create(r, g, b) when is_number(r) and is_number(g) and is_number(b) do
		%Ppm.Color{r: r, g: g, b: b}
	end

	def create([r, g, b]), do: create(r, g, b)

	def to_binary(color = %Ppm.Color{}) do
		<<color.r :: size(8),
		color.g :: size(8),
		color.b :: size(8)>>
	end
end
