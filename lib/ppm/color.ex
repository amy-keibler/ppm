defmodule Ppm.Color do

  @moduledoc """
  A color module that aids in creation of RGB value colors in the range [0, 255)
  for use in ppm images. There are helper functions to create red, green blue,
  black, and white colors.
  """

  defstruct r: 0, g: 0, b: 0

  def create(r, g, b) when is_number(r) and is_number(g) and is_number(b) do
    %Ppm.Color{r: r, g: g, b: b}
  end

  def create([r, g, b]), do: create(r, g, b)

  def create(:black), do: create(0,0,0)
  def create(:white), do: create(255,255,255)
  def create(:red), do: create(255,0,0)
  def create(:green), do: create(0,255,0)
  def create(:blue), do: create(0,0,255)

  def to_binary(color = %Ppm.Color{}) do
    <<color.r :: size(8),
      color.g :: size(8),
      color.b :: size(8)>>
  end
end
