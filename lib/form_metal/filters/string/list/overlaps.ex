defmodule FormMetal.Filters.String.List.Overlaps do
  @moduledoc """
  The 'overlaps' filter for list string values.
  """

  use FormMetal.Filters.Filter

  embedded_schema do
    field :source, {:array, :string}
    field :value, {:array, :string}
  end

  @type t() :: %__MODULE__{
          source: maybe([maybe(String.t())]),
          value: maybe([maybe(String.t())])
        }

  defimpl FormMetal.Filters.Testers.InMemory do
    import FormMetal.Filters.Builders.InMemoryUtils

    @spec test(%@for{}) :: boolean()
    def test(filter) do
      nil_guard(filter) do
        Enum.any?(filter.source, fn source ->
          Enum.any?(filter.value, fn value ->
            Ecto.Type.equal?(:string, source, value)
          end)
        end)
      end
    end
  end
end
