defmodule FormMetal.Values.Boolean do
  @moduledoc false

  @behaviour FormMetal.Values.Value

  @impl true
  def cast(nil), do: {:ok, nil}
  def cast(bool) when is_boolean(bool), do: {:ok, bool}
  def cast(_value), do: :error

  @impl true
  def load(nil), do: {:ok, nil}
  def load(bool) when is_boolean(bool), do: {:ok, bool}
  def load(_value), do: :error

  @impl true
  def dump(nil), do: {:ok, nil}
  def dump(bool) when is_boolean(bool), do: {:ok, bool}
  def dump(_value), do: :error
end
