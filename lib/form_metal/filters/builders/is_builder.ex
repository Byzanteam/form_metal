defmodule FormMetal.Filters.Builders.IsBuilder do
  @moduledoc """
  Build a `is` operator for a filter.
  """

  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      value_ecto_type = Keyword.fetch!(opts, :value_ecto_type)
      value_type = Keyword.fetch!(opts, :value_type)

      use FormMetal.Filters.Filter

      embedded_schema do
        field :source, value_ecto_type
        field :value, value_ecto_type
      end

      @type t() :: %__MODULE__{
              source: maybe(unquote(value_type)),
              value: maybe(unquote(value_type))
            }

      defimpl FormMetal.Filters.Testers.InMemory do
        alias FormMetal.Values.Value

        @spec test(%@for{}) :: boolean()
        def test(filter) do
          Ecto.Type.equal?(unquote(value_ecto_type), filter.source, filter.value)
        end
      end
    end
  end
end
