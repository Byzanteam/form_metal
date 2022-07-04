defmodule FormMetal.Filters.String.List.Include do
  @moduledoc """
  The `include` filter for list string values.
  """

  use FormMetal.Filters.Filter

  embedded_schema do
    field :source, {:array, :string}
    field :value, :string
  end

  @type t() :: %__MODULE__{
          source: maybe([maybe(String.t())]),
          value: maybe(String.t())
        }

  defimpl FormMetal.Filters.Testers.InMemory do
    import FormMetal.Filters.Builders.InMemoryUtils

    @spec test(%@for{}) :: boolean()
    def test(filter) do
      nil_guard(filter) do
        Ecto.Type.include?(:string, filter.value, filter.source)
      end
    end
  end
end
