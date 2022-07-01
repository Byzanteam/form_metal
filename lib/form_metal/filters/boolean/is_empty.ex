defmodule FormMetal.Filters.Boolean.IsEmpty do
  @moduledoc """
  The `is_empty` operator for the `boolean` value.
  """

  use FormMetal.Filters.Builders.IsBuilder,
    value_ecto_type: :boolean,
    value_type: quote(do: boolean())
end
