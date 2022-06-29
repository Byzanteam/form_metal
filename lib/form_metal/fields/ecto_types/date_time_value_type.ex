defmodule FormMetal.Fields.EctoTypes.DateTimeValueType do
  @moduledoc """
  The Ecto type for DateTimeValueType.

  ## Types

  * `datetime`: a `NaiveDateTime` struct.
  * `date`: a `NaiveDateTime` struct which the time part is the beginning of the day.
  """

  use FormMetal.StringifiedEnum, [:datetime, :date]
end
