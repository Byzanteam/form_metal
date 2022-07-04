defmodule FormMetal.Filters.String.List.Exclude do
  @moduledoc """
  The `exclude` filter for list string values.
  """

  use FormMetal.Filters.Builders.ExcludeBuilder,
    value_ecto_type: :string,
    value_type: quote(do: String.t())
end
