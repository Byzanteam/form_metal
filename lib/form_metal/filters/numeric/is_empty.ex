defmodule FormMetal.Filters.Numeric.IsEmpty do
  @moduledoc """
  The `is_empty` operator for the `numeric` value.
  """

  use FormMetal.Filters.Builders.IsBuilder,
    value_ecto_type: :decimal,
    value_type: quote(do: Decimal.t())
end
