defmodule FormMetal.Filters.String.Is do
  @moduledoc """
  The `is` operator for the `string` value.
  """

  use FormMetal.Filters.Builders.IsBuilder,
    value_ecto_type: :string,
    value_type: quote(do: String.t())

  use FormMetal.Filters.Builders.ListBuilder,
    operators: [:any, :all]
end
