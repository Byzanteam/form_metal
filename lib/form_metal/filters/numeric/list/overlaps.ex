defmodule FormMetal.Filters.Numeric.List.Overlaps do
  @moduledoc """
  The 'overlaps' filter for list decimal values.
  """

  use FormMetal.Filters.Builders.OverlapsBuilder,
    value_ecto_type: {:array, :decimal},
    value_type: quote(do: [maybe(Decimal.t())])
end
