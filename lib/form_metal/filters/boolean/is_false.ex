defmodule FormMetal.Filters.Boolean.IsFalse do
  @moduledoc """
  The `is_false` operator for boolean field.
  """

  use FormMetal.Filters.Filter

  embedded_schema do
    field :source, :boolean
  end

  @type t() :: %__MODULE__{
          source: maybe(boolean())
        }

  defimpl FormMetal.Filters.Testers.InMemory do
    @spec test(%@for{}) :: boolean()
    def test(filter) do
      filter.source === false
    end
  end
end
