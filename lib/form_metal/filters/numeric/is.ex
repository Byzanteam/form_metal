defmodule FormMetal.Filters.Numeric.Is do
  @moduledoc """
  The `is` operator for the `numeric` value.
  """

  use FormMetal.Filters.Builders.IsBuilder,
    value_ecto_type: :decimal,
    value_type: quote(do: Decimal.t())
end
