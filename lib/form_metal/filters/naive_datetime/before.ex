defmodule FormMetal.Filters.NaiveDatetime.Before do
  @moduledoc """
  The `before` operator for the `naive_datetime` value.
  """

  use FormMetal.Filters.Filter

  use FormMetal.Filters.Builders.ListBuilder,
    operators: [:any, :all]

  embedded_schema do
    field :source, :utc_datetime_usec
    field :value, :utc_datetime_usec
  end

  @type t() :: %__MODULE__{
          source: maybe(DateTime.t()),
          value: maybe(DateTime.t())
        }

  defimpl FormMetal.Filters.Testers.InMemory do
    import FormMetal.Filters.Builders.InMemoryUtils

    @spec test(%@for{}) :: boolean()
    def test(filter) do
      nil_guard(filter) do
        DateTime.compare(filter.source, filter.value) === :lt
      end
    end
  end
end
