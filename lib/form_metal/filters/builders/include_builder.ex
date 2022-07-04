defmodule FormMetal.Filters.Builders.IncludeBuilder do
  @moduledoc """
  Build a `include` operator for a list filter.
  """

  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      value_ecto_type = Keyword.fetch!(opts, :value_ecto_type)
      value_type = Keyword.fetch!(opts, :value_type)

      use FormMetal.Filters.Filter

      embedded_schema do
        field :source, {:array, value_ecto_type}
        field :value, value_ecto_type
      end

      @type t() :: %__MODULE__{
              source: maybe([maybe(unquote(value_type))]),
              value: maybe(unquote(value_type))
            }

      defimpl FormMetal.Filters.Testers.InMemory do
        alias FormMetal.Values.Value
        import FormMetal.Filters.Builders.InMemoryUtils

        @spec test(%@for{}) :: boolean()
        def test(filter) do
          nil_guard(filter) do
            Value.include?(unquote(value_ecto_type), filter.value, filter.source)
          end
        end
      end
    end
  end
end
