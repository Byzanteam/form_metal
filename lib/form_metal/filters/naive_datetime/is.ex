defmodule FormMetal.Filters.NaiveDatetime.Is do
  @moduledoc """
  The `is` operator for the `naive_datetime` value.
  """

  use FormMetal.Filters.Builders.IsBuilder,
    value_ecto_type: :utc_datetime_usec,
    value_type: quote(do: DateTime.t())

  use FormMetal.Filters.Builders.ListBuilder,
    operators: [:any, :all]
end
