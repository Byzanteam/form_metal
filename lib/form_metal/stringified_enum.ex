defmodule FormMetal.StringifiedEnum do
  @moduledoc """
  Defining an Enum Ecto type.

  ```elixir
  defmodule EnumType do
    use FormMetal.StringifiedEnum, [:foo, :bar]
  end
  ```

  ```
  # cast
  iex> EnumType.cast("foo")
  {:ok, :foo}
  iex> EnumType.cast("FOO")
  {:ok, :foo}
  iex> EnumType.cast(:foo)
  {:ok, :foo}

  # load
  iex> EnumType.load("foo")
  {:ok, :foo}
  iex> EnumType.load("FOO")
  {:ok, :foo}

  # dump
  iex> EnumType.dump(:foo)
  {:ok, "FOO"}
  ```
  """

  defmacro __using__(values) do
    quote location: :keep, bind_quoted: [values: values] do
      unless is_list(values) and Enum.all?(values, &is_atom/1) do
        raise ArgumentError, """
        Types using `FormMetal.StringifiedEnum` must have a values option specified as a list of atoms. For example:

            use FormMetal.StringifiedEnum, [:foo, :bar]
        """
      end

      typespec = FormMetal.StringifiedEnum.make_sum_type(values)

      use Ecto.Type

      @type t() :: unquote(typespec)

      @cast_mapping Enum.reduce(values, %{}, fn value, acc ->
                      acc
                      |> Map.put(Atom.to_string(value), value)
                      |> Map.put(value |> Atom.to_string() |> String.upcase(), value)
                    end)

      @load_mapping Map.new(values, fn value ->
                      {value,
                       [Atom.to_string(value), value |> Atom.to_string() |> String.upcase()]}
                    end)

      @dump_mapping Map.new(values, &{&1, &1 |> Atom.to_string() |> String.upcase()})

      @impl Ecto.Type
      def type, do: :string

      @impl Ecto.Type
      def embed_as(_data), do: :self

      @impl Ecto.Type
      def cast(nil), do: {:ok, nil}

      @impl Ecto.Type
      def cast(data) do
        case {@cast_mapping, @dump_mapping} do
          {%{^data => as_atom}, _} -> {:ok, as_atom}
          {_, %{^data => _}} -> {:ok, data}
          _other -> :error
        end
      end

      @impl Ecto.Type
      def load(nil), do: {:ok, nil}

      @impl Ecto.Type
      for {as_atom, values} <- @load_mapping do
        def load(unquote(as_atom)), do: {:ok, unquote(as_atom)}

        for value <- values do
          def load(unquote(value)), do: {:ok, unquote(as_atom)}
        end
      end

      def load(_data), do: :error

      @impl Ecto.Type
      def dump(nil), do: {:ok, nil}

      @impl Ecto.Type
      def dump(data) do
        case @dump_mapping do
          %{^data => as_string} -> {:ok, as_string}
          _mapping -> :error
        end
      end

      # Reflections
      @spec __values__() :: [t()]
      def __values__, do: unquote(values)
    end
  end

  @spec make_sum_type([atom(), ...]) :: Macro.t()
  def make_sum_type(types) do
    types
    |> Enum.reverse()
    |> Enum.reduce(fn type, acc when is_atom(type) ->
      quote do: unquote(type) | unquote(acc)
    end)
  end
end
