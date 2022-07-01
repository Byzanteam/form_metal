defmodule FormMetal.Filters.String.List.Is do
  @moduledoc """
  The `is` operator for the list `string` value.
  """

  use FormMetal.Filters.Builders.IsBuilder,
    value_ecto_type: {:array, :string},
    value_type: quote(do: [maybe(String.t())])
end
