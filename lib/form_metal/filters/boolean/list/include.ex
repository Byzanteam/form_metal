defmodule FormMetal.Filters.Boolean.List.Include do
  @moduledoc """
  The `include` filter for list boolean values.
  """

  use FormMetal.Filters.Builders.IncludeBuilder,
    value_ecto_type: :boolean,
    value_type: quote(do: boolean())
end
