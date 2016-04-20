defmodule Ppm.Tuple2DTest do
	use ExUnit.Case
	doctest Ppm.Tuple2D

	test "create tuple of proper size" do
		assert Ppm.Tuple2D.create(2,3) == {{0,0},{0,0},{0,0}}
	end

	test "create image with custom initial" do
		assert Ppm.Tuple2D.create(2,3,1) == {{1,1},{1,1},{1,1}}
	end

	test "set tuple element" do
		tuple = {{0,0},{0,0},{0,0}}
		assert Ppm.Tuple2D.set(tuple, 0, 1, 1) == {{0,0},{1,0},{0,0}}
	end

	test "create tuple of invalid size" do
		assert_raise(FunctionClauseError, fn -> Ppm.Tuple2D.create(0,1) end)
		assert_raise(FunctionClauseError, fn -> Ppm.Tuple2D.create(-1,1) end)
		assert_raise(FunctionClauseError, fn -> Ppm.Tuple2D.create(1,0) end)
		assert_raise(FunctionClauseError, fn -> Ppm.Tuple2D.create(1,-1) end)
	end

	test "set invalid element" do
		tuple = {{0}}
		assert_raise(ArgumentError, fn -> Ppm.Tuple2D.set(tuple, 0, 1, 1) end)
		assert_raise(ArgumentError, fn -> Ppm.Tuple2D.set(tuple, 1, 0, 1) end)
		assert_raise(FunctionClauseError, fn -> Ppm.Tuple2D.set(tuple, 0, -1, 1) end)
		assert_raise(FunctionClauseError, fn -> Ppm.Tuple2D.set(tuple, -1, 0, 1) end)
	end
end
