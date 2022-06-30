defmodule FormMetal.Values.Value do
  @moduledoc """
  The `FormMetal.Values.Value` module defines the contract for field values.
  """

  @callback cast(term()) :: {:ok, term()} | :error | {:error, Keyword.t()}
  @callback load(term()) :: {:ok, term()} | :error
  @callback dump(term()) :: {:ok, term()} | :error

  @value_types [:boolean, :decimal, :naive_date_time, :string]

  for value_type <- @value_types do
    value_module =
      Module.safe_concat(
        FormMetal.Values,
        value_type |> Atom.to_string() |> Macro.camelize()
      )

    @spec cast(unquote(value_type), term()) :: {:ok, term()} | :error | {:error, Keyword.t()}
    def cast(unquote(value_type), nil), do: {:ok, nil}
    def cast(unquote(value_type), value), do: unquote(value_module).cast(value)

    @spec load(unquote(value_type), term()) :: {:ok, term()} | :error
    def load(unquote(value_type), nil), do: {:ok, nil}
    def load(unquote(value_type), value), do: unquote(value_module).load(value)

    @spec dump(unquote(value_type), term()) :: {:ok, term()} | :error
    def dump(unquote(value_type), nil), do: {:ok, nil}
    def dump(unquote(value_type), value), do: unquote(value_module).dump(value)
  end
end
