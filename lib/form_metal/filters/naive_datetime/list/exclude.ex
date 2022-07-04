defmodule FormMetal.Filters.NaiveDatetime.List.Exclude do
  @moduledoc """
  The `exclude` filter for list naive_datetime values.
  """

  use FormMetal.Filters.Builders.ExcludeBuilder,
    value_ecto_type: :naive_datetime_usec,
    value_type: quote(do: NaiveDateTime.t())
end
