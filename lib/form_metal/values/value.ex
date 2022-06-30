defmodule FormMetal.Values.Value do
  @moduledoc """
  The `FormMetal.Values.Value` module defines the contract for field values.
  """

  @callback cast(term()) :: {:ok, term()} | :error | {:error, Keyword.t()}
  @callback load(term()) :: {:ok, term()} | :error
  @callback dump(term()) :: {:ok, term()} | :error

  @value_types [:boolean, :decimal, :naive_date_time, :string]

  @typep singular_value_type() :: module() | atom()
  @typep value_type() :: singular_value_type() | {:list, singular_value_type()}

  @spec cast(value_type(), term()) :: {:ok, term()} | :error | {:error, Keyword.t()}
  def cast(value_type, value)

  @spec load(value_type(), term()) :: {:ok, term()} | :error
  def load(value_type, value)

  @spec dump(value_type(), term()) :: {:ok, term()} | :error
  def dump(value_type, value)

  for value_type <- @value_types do
    value_module =
      Module.safe_concat(
        FormMetal.Values,
        value_type |> Atom.to_string() |> Macro.camelize()
      )

    def cast(unquote(value_type), nil), do: {:ok, nil}
    def cast(unquote(value_type), value), do: unquote(value_module).cast(value)
    def cast({:list, unquote(value_type)}, nil), do: {:ok, nil}
    def cast({:list, unquote(value_type)}, []), do: {:ok, nil}

    def cast({:list, unquote(value_type)}, values) when is_list(values),
      do: do_cast_list(unquote(value_type), values)

    def load(unquote(value_type), nil), do: {:ok, nil}
    def load(unquote(value_type), value), do: unquote(value_module).load(value)
    def load({:list, unquote(value_type)}, nil), do: {:ok, nil}
    def load({:list, unquote(value_type)}, []), do: {:ok, nil}

    def load({:list, unquote(value_type)}, values) when is_list(values),
      do: do_load_list(unquote(value_type), values)

    def dump(unquote(value_type), nil), do: {:ok, nil}
    def dump(unquote(value_type), value), do: unquote(value_module).dump(value)
    def dump({:list, unquote(value_type)}, nil), do: {:ok, nil}
    def dump({:list, unquote(value_type)}, []), do: {:ok, nil}

    def dump({:list, unquote(value_type)}, values) when is_list(values),
      do: do_dump_list(unquote(value_type), values)
  end

  def cast(_value_module, nil), do: {:ok, nil}
  def cast(value_module, value), do: value_module.cast(value)

  def load(_value_module, nil), do: {:ok, nil}
  def load(value_module, value), do: value_module.load(value)

  def dump(_value_module, nil), do: {:ok, nil}
  def dump(value_module, value), do: value_module.dump(value)

  for fun_name <- [:cast, :load, :dump] do
    # credo:disable-for-next-line Credo.Check.Warning.UnsafeToAtom
    list_do_fun_name = :"do_#{fun_name}_list"

    defp unquote(list_do_fun_name)(value_type, values) do
      values
      |> Enum.reduce_while([], fn value, acc ->
        case unquote(fun_name)(value_type, value) do
          {:ok, value} -> {:cont, [value | acc]}
          :error -> {:halt, :error}
        end
      end)
      |> case do
        :error -> :error
        list -> {:ok, Enum.reverse(list)}
      end
    end
  end
end
