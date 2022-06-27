defmodule FormMetal.StringifiedEnumTest do
  use ExUnit.Case, async: true

  defmodule MyState do
    use FormMetal.StringifiedEnum, [:active, :foo_bar]
  end

  test "cast/1" do
    assert_pairs(
      &MyState.cast/1,
      [
        {"active", {:ok, :active}},
        {:active, {:ok, :active}},
        {"ACTIVE", {:ok, :active}},
        {"foo_bar", {:ok, :foo_bar}},
        {:foo_bar, {:ok, :foo_bar}},
        {"FOO_BAR", {:ok, :foo_bar}},
        {:other, :error},
        {"other", :error},
        {"OTHER", :error}
      ]
    )
  end

  test "load/1" do
    assert_pairs(
      &MyState.load/1,
      [
        {"active", {:ok, :active}},
        {:active, {:ok, :active}},
        {"ACTIVE", {:ok, :active}},
        {"foo_bar", {:ok, :foo_bar}},
        {:foo_bar, {:ok, :foo_bar}},
        {"FOO_BAR", {:ok, :foo_bar}},
        {:other, :error},
        {"other", :error},
        {"OTHER", :error}
      ]
    )
  end

  test "dump/1" do
    assert_pairs(
      &MyState.dump/1,
      [
        {"active", :error},
        {:active, {:ok, "ACTIVE"}},
        {"ACTIVE", :error},
        {"foo_bar", :error},
        {:foo_bar, {:ok, "FOO_BAR"}},
        {"FOO_BAR", :error},
        {:other, :error},
        {"other", :error},
        {"OTHER", :error}
      ]
    )
  end

  test "__values__/0" do
    assert MyState.__values__() === [:active, :foo_bar]
  end

  defp assert_pairs(fun, pairs) do
    Enum.each(pairs, fn {left, right} ->
      value = fun.(left)

      assert value === right,
             "Expected #{inspect(value)} (#{inspect(left)}) to be #{inspect(right)}"
    end)
  end
end
