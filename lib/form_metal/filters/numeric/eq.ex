defmodule FormMetal.Filters.Numeric.Eq do
  @moduledoc """
  The `eq` operator for the `numeric` value.
  """

  use FormMetal.Filters.Filter

  use FormMetal.Filters.Builders.ListBuilder,
    operators: [:any, :all]

  embedded_schema do
    field :source, :decimal
    field :value, :decimal
  end

  @type t() :: %__MODULE__{
          source: maybe(Decimal.t()),
          value: maybe(Decimal.t())
        }

  defimpl FormMetal.Filters.Testers.InMemory do
    import FormMetal.Filters.Builders.InMemoryUtils

    @spec test(%@for{}) :: boolean()
    def test(filter) do
      nil_guard(filter) do
        Decimal.compare(filter.source, filter.value) === :eq
      end
    end
  end
end
