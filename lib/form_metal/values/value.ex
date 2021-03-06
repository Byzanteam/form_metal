defmodule FormMetal.Values.Value do
  @moduledoc """
  The `FormMetal.Values.Value` module handles the value of a field.
  """

  @spec cast(Ecto.Type.t(), term()) :: {:ok, term()} | :error | {:error, Keyword.t()}
  def cast({:array, _value_type}, []), do: {:ok, nil}
  def cast(value_type, value), do: Ecto.Type.cast(value_type, value)

  @spec load(Ecto.Type.t(), term()) :: {:ok, term()} | :error
  def load({:array, _value_type}, []), do: {:ok, nil}
  def load(value_type, value), do: Ecto.Type.load(value_type, value)

  @spec dump(Ecto.Type.t(), term()) :: {:ok, term()} | :error
  def dump({:array, _value_type}, []), do: {:ok, nil}
  def dump(value_type, value), do: Ecto.Type.dump(value_type, value)

  @spec equal?(Ecto.Type.t(), term(), term()) :: boolean()
  def equal?(type, term1, term2) do
    Ecto.Type.equal?(type, term1, term2)
  end

  @spec include?(Ecto.Type.t(), term(), Enum.t()) :: boolean()
  def include?(type, term, collection) do
    Ecto.Type.include?(type, term, collection)
  end
end
