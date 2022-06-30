defmodule FormMetal.Values.ListValuesTest do
  use ExUnit.Case, async: true

  alias FormMetal.Values.Value

  test "cast/2" do
    assert {:ok, nil} === Value.cast({:list, :string}, [])
    assert {:ok, nil} === Value.cast({:list, :string}, nil)
    assert {:ok, ["foo", nil]} === Value.cast({:list, :string}, ["foo", nil])
    assert :error === Value.cast({:list, :string}, ["foo", nil, 1])
  end

  test "load/2" do
    assert {:ok, nil} === Value.load({:list, :string}, [])
    assert {:ok, nil} === Value.load({:list, :string}, nil)
    assert {:ok, ["foo", nil]} === Value.load({:list, :string}, ["foo", nil])
    assert :error === Value.load({:list, :string}, ["foo", nil, 1])
  end

  test "dump/2" do
    assert {:ok, nil} === Value.dump({:list, :string}, [])
    assert {:ok, nil} === Value.dump({:list, :string}, nil)
    assert {:ok, ["foo", nil]} === Value.dump({:list, :string}, ["foo", nil])
    assert :error === Value.dump({:list, :string}, ["foo", nil, 1])
  end
end
