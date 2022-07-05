defmodule FormMetal.Filters.Numeric.List.Exclude do
  @moduledoc """
  The `exclude` filter for list decimal values.
  """

  use FormMetal.Filters.Builders.ExcludeBuilder,
    value_ecto_type: :decimal,
    value_type: quote(do: Decimal.t())
end
