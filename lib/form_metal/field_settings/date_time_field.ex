defmodule FormMetal.FieldSettings.DateTimeField do
  @moduledoc """
  FieldSettings for DateTimeField.
  """

  defmodule ValueType do
    @moduledoc false

    use FormMetal.StringifiedEnum, [:datetime, :date]
  end

  use FormMetal.FieldSettings

  @type t() :: %__MODULE__{
          type: ValueType.t()
        }

  embedded_schema do
    field :type, ValueType
  end

  @impl FormMetal.FieldSettings
  def changeset(%__MODULE__{} = data, params) do
    data
    |> Ecto.Changeset.cast(params, [:type])
    |> Ecto.Changeset.validate_required([:type])
  end
end
