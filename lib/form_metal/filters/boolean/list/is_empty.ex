defmodule FormMetal.Filters.Boolean.List.IsEmpty do
  @moduledoc """
  The `is_empty` operator for the list `boolean` value.
  """

  use FormMetal.Filters.Builders.IsEmptyBuilder,
    value_ecto_type: {:array, :boolean},
    value_type: quote(do: [maybe(boolean())])
end
