defmodule FormMetal.Filters.Boolean.List.Is do
  @moduledoc """
  The `is` operator for the list `boolean` value.
  """

  use FormMetal.Filters.Builders.IsBuilder,
    value_ecto_type: {:array, :boolean},
    value_type: quote(do: [maybe(boolean())])
end
