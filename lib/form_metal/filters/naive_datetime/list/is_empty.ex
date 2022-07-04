defmodule FormMetal.Filters.NaiveDatetime.List.IsEmpty do
  @moduledoc """
  The `is_empty` operator for the list `naive_datetime` value.
  """

  use FormMetal.Filters.Builders.IsEmptyBuilder,
    value_ecto_type: {:array, :naive_datetime_usec},
    value_type: quote(do: [maybe(NaiveDateTime.t())])
end
