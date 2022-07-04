defmodule FormMetal.Filters.String.List.Include do
  @moduledoc """
  The `include` filter for list string values.
  """

  use FormMetal.Filters.Builders.IncludeBuilder,
    value_ecto_type: :string,
    value_type: quote(do: String.t())
end
