defmodule FormMetal.Filters.NaiveDatetime.List.Overlaps do
  @moduledoc """
  The 'overlaps' filter for list naive_datetime values.
  """

  use FormMetal.Filters.Builders.OverlapsBuilder,
    value_ecto_type: {:array, :naive_datetime_usec},
    value_type: quote(do: [maybe(NaiveDateTime.t())])
end
