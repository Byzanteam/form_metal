defmodule FormMetal.Filters.String.List.Overlaps do
  @moduledoc """
  The 'overlaps' filter for list string values.
  """

  use FormMetal.Filters.Builders.OverlapsBuilder,
    value_ecto_type: {:array, :string},
    value_type: quote(do: [maybe(String.t())])
end
