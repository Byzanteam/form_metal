defmodule FormMetal.Filters.Numeric.List.Include do
  @moduledoc """
  The `include` filter for list decimal values.
  """

  use FormMetal.Filters.Builders.IncludeBuilder,
    value_ecto_type: :decimal,
    value_type: quote(do: Decimal.t())
end
