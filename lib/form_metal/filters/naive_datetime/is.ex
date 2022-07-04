defmodule FormMetal.Filters.NaiveDatetime.Is do
  @moduledoc """
  The `is` operator for the `naive_datetime` value.
  """

  use FormMetal.Filters.Builders.IsBuilder,
    value_ecto_type: :naive_datetime_usec,
    value_type: quote(do: NaiveDateTime.t())

  use FormMetal.Filters.Builders.ListBuilder,
    operators: [:any, :all]
end
