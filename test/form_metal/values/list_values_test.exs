defmodule FormMetal.Values.ListValuesTest do
  use ExUnit.Case, async: true

  alias FormMetal.Values.Value

  test "cast/2" do
    assert {:ok, nil} === Value.cast({:array, :string}, [])
    assert {:ok, nil} === Value.cast({:array, :string}, nil)
    assert {:ok, ["foo", nil]} === Value.cast({:array, :string}, ["foo", nil])
    assert :error === Value.cast({:array, :string}, ["foo", nil, 1])
  end

  test "load/2" do
    assert {:ok, nil} === Value.load({:array, :string}, [])
    assert {:ok, nil} === Value.load({:array, :string}, nil)
    assert {:ok, ["foo", nil]} === Value.load({:array, :string}, ["foo", nil])
    assert :error === Value.load({:array, :string}, ["foo", nil, 1])
  end

  test "dump/2" do
    assert {:ok, nil} === Value.dump({:array, :string}, [])
    assert {:ok, nil} === Value.dump({:array, :string}, nil)
    assert {:ok, ["foo", nil]} === Value.dump({:array, :string}, ["foo", nil])
    assert :error === Value.dump({:array, :string}, ["foo", nil, 1])
  end
end
