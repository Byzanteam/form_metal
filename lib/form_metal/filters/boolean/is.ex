defmodule FormMetal.Filters.Boolean.Is do
  @moduledoc """
  The `is` operator for the `boolean` value.
  """

  use FormMetal.Filters.Builders.IsBuilder,
    value_ecto_type: :boolean,
    value_type: quote(do: boolean())
end
