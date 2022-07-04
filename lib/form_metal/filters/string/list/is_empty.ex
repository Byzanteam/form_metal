defmodule FormMetal.Filters.String.List.IsEmpty do
  @moduledoc """
  The `is_empty` operator for the list `string` value.
  """

  use FormMetal.Filters.Builders.IsEmptyBuilder,
    value_ecto_type: {:array, :string},
    value_type: quote(do: [maybe(String.t())])
end
