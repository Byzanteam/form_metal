defmodule FormMetal.Values.Decimal do
  @moduledoc false

  @behaviour FormMetal.Values.Value

  import Decimal, only: [is_decimal: 1]
  alias Decimal, as: D

  @impl true
  def cast(nil), do: {:ok, nil}
  def cast(decimal) when is_decimal(decimal), do: {:ok, decimal}
  def cast(float) when is_float(float), do: {:ok, D.from_float(float)}
  def cast(int) when is_integer(int), do: {:ok, D.new(int)}

  def cast(str) when is_binary(str),
    do: with({decimal, _binary} <- D.parse(str), do: {:ok, decimal})

  def cast(_value), do: :error

  @impl true
  def load(nil), do: {:ok, nil}
  def load(decimal) when is_decimal(decimal), do: {:ok, decimal}
  def load(_value), do: :error

  @impl true
  def dump(nil), do: {:ok, nil}
  def dump(decimal) when is_decimal(decimal), do: {:ok, decimal}
  def dump(_value), do: :error
end
