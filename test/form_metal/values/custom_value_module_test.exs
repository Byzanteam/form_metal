defmodule FormMetal.Values.CustomValueModuleTest do
  use ExUnit.Case, async: true

  alias FormMetal.Values.Value

  defmodule MyAtomValue do
    @behaviour FormMetal.Values.Value

    @impl true
    # credo:disable-for-next-line Credo.Check.Warning.UnsafeToAtom
    def cast(str) when is_binary(str), do: {:ok, String.to_atom(str)}
    def cast(atom) when is_atom(atom), do: {:ok, atom}
    def cast(_value), do: :error

    @impl true
    def load(nil), do: {:ok, nil}
    # credo:disable-for-next-line Credo.Check.Warning.UnsafeToAtom
    def load(str) when is_binary(str), do: {:ok, String.to_atom(str)}
    def load(_value), do: :error

    @impl true
    def dump(nil), do: {:ok, nil}
    def dump(atom) when is_atom(atom), do: {:ok, Atom.to_string(atom)}
    def dump(_value), do: :error
  end

  test "cast/2" do
    assert {:ok, :foo} === Value.cast(MyAtomValue, "foo")
    assert {:ok, :foo} === Value.cast(MyAtomValue, :foo)
    assert :error === Value.cast(MyAtomValue, 1)
  end

  test "load/2" do
    assert {:ok, :foo} === Value.load(MyAtomValue, "foo")
    assert :error === Value.load(MyAtomValue, 1)
  end

  test "dump/2" do
    assert {:ok, "foo"} === Value.dump(MyAtomValue, :foo)
    assert {:ok, nil} === Value.dump(MyAtomValue, nil)
    assert :error === Value.dump(MyAtomValue, 1)
  end
end
