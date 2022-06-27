defmodule FormMetal.FieldSettings do
  @moduledoc """
  Define a concrete FieldSettings schema.
  """

  @type settings() :: Ecto.Schema.embedded_schema()

  @doc "Make a field settings change"
  @callback changeset(settings, params :: map()) :: Ecto.Changeset.t(settings)
            when settings: settings()

  # Reflections
  @callback __empty_settings__() :: boolean()

  defmacro __using__(opts) do
    prelude =
      quote do
        use Ecto.Schema

        @primary_key false
        @timestamps_opts [type: :naive_datetime_usec]

        @behaviour unquote(__MODULE__)
      end

    if Keyword.get(opts, :empty_settings?) do
      [
        prelude,
        quote do
          @type t() :: %__MODULE__{}

          embedded_schema do
          end

          @impl unquote(__MODULE__)
          def changeset(%__MODULE__{} = data, params) do
            Ecto.Changeset.cast(data, params, [])
          end

          @impl unquote(__MODULE__)
          def __empty_settings__, do: true
        end
      ]
    else
      [
        prelude,
        quote do
          @impl unquote(__MODULE__)
          def __empty_settings__, do: false
        end
      ]
    end
  end
end
