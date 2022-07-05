defmodule FormMetal.Filters.NaiveDatetime.OnOrBefore do
  @moduledoc """
  The `on_or_before` operator for the `naive_datetime` value.
  """

  use FormMetal.Filters.Filter

  use FormMetal.Filters.Builders.ListBuilder,
    operators: [:any, :all]

  embedded_schema do
    field :source, :naive_datetime_usec
    field :value, :naive_datetime_usec
  end

  @type t() :: %__MODULE__{
          source: maybe(NaiveDateTime.t()),
          value: maybe(NaiveDateTime.t())
        }

  defimpl FormMetal.Filters.Testers.InMemory do
    import FormMetal.Filters.Builders.InMemoryUtils

    @spec test(%@for{}) :: boolean()
    def test(filter) do
      nil_guard(filter) do
        NaiveDateTime.compare(filter.source, filter.value) in [:eq, :lt]
      end
    end
  end
end
