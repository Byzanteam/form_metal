defmodule FormMetal.Filters.NaiveDatetime.List.Is do
  @moduledoc """
  The `is` operator for the list `naive_datetime` value.
  """

  use FormMetal.Filters.Builders.IsBuilder,
    value_ecto_type: {:array, :utc_datetime_usec},
    value_type: quote(do: [maybe(DateTime.t())])
end
