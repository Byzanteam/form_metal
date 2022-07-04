defmodule FormMetal.Filters.String.IsEmpty do
  @moduledoc """
  The `is_empty` operator for the `string` value.
  """

  use FormMetal.Filters.Builders.IsEmptyBuilder,
    value_ecto_type: :string,
    value_type: quote(do: String.t())

  use FormMetal.Filters.Builders.ListBuilder,
    operators: [:any, :all]
end
