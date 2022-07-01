defmodule FormMetal.Filters.Builders.IsEmptyBuilder do
  @moduledoc """
  Build a `is_empty` operator for a filter.
  """

  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      value_ecto_type = Keyword.fetch!(opts, :value_ecto_type)
      value_type = Keyword.fetch!(opts, :value_type)

      use FormMetal.Filters.Filter

      embedded_schema do
        field :source, value_ecto_type
      end

      @type t() :: %__MODULE__{
              source: maybe(unquote(value_type))
            }

      defimpl FormMetal.Filters.Testers.InMemory do
        @spec test(%@for{}) :: boolean()
        def test(filter) do
          is_nil(filter.source)
        end
      end
    end
  end
end
