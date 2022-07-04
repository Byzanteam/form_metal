defmodule FormMetal.Filters.Boolean.List.Exclude do
  @moduledoc """
  The `exclude` filter for list boolean values.
  """

  use FormMetal.Filters.Builders.ExcludeBuilder,
    value_ecto_type: :boolean,
    value_type: quote(do: boolean())
end
