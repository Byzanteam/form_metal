defmodule FormMetal.Fields.EctoTypes.NumericValueType do
  @moduledoc """
  The Ecto type for NumericValueType.

  ## Types

  * `integer`: The integer type.
  * `decimal`: The decimal type.
  """

  use FormMetal.StringifiedEnum, [:integer, :decimal]
end
