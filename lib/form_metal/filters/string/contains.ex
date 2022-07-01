defmodule FormMetal.Filters.String.Contains do
  @moduledoc """
  The `contains` operator for the `string` value.
  """

  use FormMetal.Filters.Filter

  embedded_schema do
    field :source, :string
    field :value, :string
  end

  @type t() :: %__MODULE__{
          source: maybe(String.t()),
          value: maybe(String.t())
        }

  defimpl FormMetal.Filters.Testers.InMemory do
    import FormMetal.Filters.Builders.InMemoryUtils

    @spec test(%@for{}) :: boolean()
    def test(filter) do
      nil_guard(filter) do
        String.contains?(filter.source, filter.value)
      end
    end
  end
end
