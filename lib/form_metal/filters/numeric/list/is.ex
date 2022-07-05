defmodule FormMetal.Filters.Numeric.List.Is do
  @moduledoc """
  The `is` operator for the list `decimal` value.
  """

  use FormMetal.Filters.Builders.IsBuilder,
    value_ecto_type: {:array, :decimal},
    value_type: quote(do: [maybe(Decimal.t())])
end
