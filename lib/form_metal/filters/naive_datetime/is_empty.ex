defmodule FormMetal.Filters.NaiveDatetime.IsEmpty do
  @moduledoc """
  The `is_empty` operator for the `naive_datetime` value.
  """

  use FormMetal.Filters.Builders.IsEmptyBuilder,
    value_ecto_type: :naive_datetime_usec,
    value_type: quote(do: NaiveDateTime.t())

  use FormMetal.Filters.Builders.ListBuilder,
    operators: [:any, :all]
end
