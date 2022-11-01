defmodule FormMetal.Filters.NaiveDatetime.Between do
  @moduledoc """
  The `between` operator for the `naive_datetime` value.

  The `start_at` and `end_at` are inclusive.
  """

  use FormMetal.Filters.Filter

  use FormMetal.Filters.Builders.ListBuilder,
    operators: [:any, :all]

  embedded_schema do
    field :source, :utc_datetime_usec
    field :start_at, :utc_datetime_usec
    field :end_at, :utc_datetime_usec
  end

  @type t() :: %__MODULE__{
          source: maybe(DateTime.t()),
          start_at: maybe(DateTime.t()),
          end_at: maybe(DateTime.t())
        }

  defimpl FormMetal.Filters.Testers.InMemory do
    import FormMetal.Filters.Builders.InMemoryUtils

    @spec test(%@for{}) :: boolean()
    def test(filter) do
      nil_guard(filter) do
        DateTime.compare(filter.source, filter.start_at) in [:eq, :lt] &&
          DateTime.compare(filter.source, filter.end_at) in [:eq, :gt]
      end
    end
  end
end
