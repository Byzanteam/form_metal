defmodule FormMetal.Filters.NaiveDatetime.List.Include do
  @moduledoc """
  The `include` filter for list naive_datetime values.
  """

  use FormMetal.Filters.Builders.IncludeBuilder,
    value_ecto_type: :naive_datetime_usec,
    value_type: quote(do: NaiveDateTime.t())
end
