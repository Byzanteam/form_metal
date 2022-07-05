defmodule FormMetal.Filters.Numeric.List.IsEmpty do
  @moduledoc """
  The `is_empty` operator for the list `decimal` value.
  """

  use FormMetal.Filters.Builders.IsEmptyBuilder,
    value_ecto_type: {:array, :decimal},
    value_type: quote(do: [maybe(Decimal.t())])
end
