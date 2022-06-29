defmodule FormMetal.Fields.Field do
  @moduledoc """
  Defines `FormMetal.Fields.Field` contract.
  """

  @type field() :: Ecto.Schema.embedded_schema()

  @doc "Make a field change."
  @callback changeset(field, params :: map()) :: Ecto.Changeset.t(field) when field: field()

  defmacro __before_compile__(_env) do
    quote do
      unless Module.defines_type?(__MODULE__, {:t, 0}) do
        raise ArgumentError, """
        the module #{inspect(__MODULE__)} does not define a `t/0` type.
        """
      end
    end
  end
end
