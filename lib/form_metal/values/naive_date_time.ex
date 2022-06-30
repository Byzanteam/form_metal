defmodule FormMetal.Values.NaiveDateTime do
  @moduledoc false

  @behaviour FormMetal.Values.Value

  @impl true
  def cast(nil), do: {:ok, nil}
  def cast(ndt) when is_struct(ndt, NaiveDateTime), do: {:ok, ndt}
  def cast(dt) when is_struct(dt, DateTime), do: {:ok, DateTime.to_naive(dt)}

  def cast(str) when is_binary(str),
    do: with({:error, _reason} <- NaiveDateTime.from_iso8601(str), do: :error)

  def cast(_value), do: :error

  @impl true
  def load(nil), do: {:ok, nil}
  def load(ndt) when is_struct(ndt, NaiveDateTime), do: {:ok, ndt}
  def load(_value), do: :error

  @impl true
  def dump(nil), do: {:ok, nil}
  def dump(ndt) when is_struct(ndt, NaiveDateTime), do: {:ok, ndt}
  def dump(_value), do: :error
end
