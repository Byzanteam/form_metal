defmodule FormMetal.Fields.Builder do
  @moduledoc """
  Define Field builder contract.
  """

  @doc """
  The callback invoked to build a field.
  """
  @macrocallback build_field(Keyword.t(), do: Macro.t()) :: Macro.t()

  @doc """
  The callback invoked to build the type for a field.
  """
  @macrocallback build_field_type(Macro.t()) :: Macro.t()
end
