defmodule FormMetal.Values.Value do
  @moduledoc """
  The `FormMetal.Values.Value` module defines the contract for field values.
  """

  @callback cast(term()) :: {:ok, term()} | :error | {:error, Keyword.t()}
  @callback load(term()) :: {:ok, term()} | :error
  @callback dump(term()) :: {:ok, term()} | :error

  @value_types [:boolean, :decimal, :naive_date_time, :string]

  @spec cast(module() | atom(), term()) :: {:ok, term()} | :error | {:error, Keyword.t()}
  def cast(value_type_or_module, value)

  @spec load(module() | atom(), term()) :: {:ok, term()} | :error
  def load(value_type_or_module, value)

  @spec dump(module() | atom(), term()) :: {:ok, term()} | :error
  def dump(value_type_or_module, value)

  for value_type <- @value_types do
    value_module =
      Module.safe_concat(
        FormMetal.Values,
        value_type |> Atom.to_string() |> Macro.camelize()
      )

    def cast(unquote(value_type), nil), do: {:ok, nil}
    def cast(unquote(value_type), value), do: unquote(value_module).cast(value)

    def load(unquote(value_type), nil), do: {:ok, nil}
    def load(unquote(value_type), value), do: unquote(value_module).load(value)

    def dump(unquote(value_type), nil), do: {:ok, nil}
    def dump(unquote(value_type), value), do: unquote(value_module).dump(value)
  end

  def cast(_value_module, nil), do: {:ok, nil}
  def cast(value_module, value), do: value_module.cast(value)

  def load(_value_module, nil), do: {:ok, nil}
  def load(value_module, value), do: value_module.load(value)

  def dump(_value_module, nil), do: {:ok, nil}
  def dump(value_module, value), do: value_module.dump(value)
end
