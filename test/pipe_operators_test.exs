defmodule PipeOperatorsTest do
  use ExUnit.Case
  doctest PipeOperators

  test "greets the world" do
    assert PipeOperators.hello() == :world
  end
end
