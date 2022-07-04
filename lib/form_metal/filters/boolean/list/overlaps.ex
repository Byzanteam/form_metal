defmodule FormMetal.Filters.Boolean.List.Overlaps do
  @moduledoc """
  The 'overlaps' filter for list boolean values.
  """

  use FormMetal.Filters.Builders.OverlapsBuilder,
    value_ecto_type: {:array, :boolean},
    value_type: quote(do: [maybe(boolean())])
end
