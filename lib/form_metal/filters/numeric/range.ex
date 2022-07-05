defmodule FormMetal.Filters.Numeric.Range do
  @moduledoc """
  The `range` operator for the `numeric` value.

  The 'minimum` and `maximum` values are inclusive.
  """

  use FormMetal.Filters.Filter

  use FormMetal.Filters.Builders.ListBuilder,
    operators: [:any, :all]

  embedded_schema do
    field :source, :decimal
    field :minimum, :decimal
    field :maximum, :decimal
  end

  @type t() :: %__MODULE__{
          source: maybe(Decimal.t()),
          minimum: maybe(Decimal.t()),
          maximum: maybe(Decimal.t())
        }

  defimpl FormMetal.Filters.Testers.InMemory do
    import FormMetal.Filters.Builders.InMemoryUtils

    @spec test(%@for{}) :: boolean()
    def test(filter) do
      nil_guard(filter) do
        Decimal.compare(filter.source, filter.minimum) in [:eq, :gt] &&
          Decimal.compare(filter.source, filter.maximum) in [:eq, :lt]
      end
    end
  end
end
