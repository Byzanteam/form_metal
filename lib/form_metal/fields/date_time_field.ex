defmodule FormMetal.Fields.DateTimeField do
  @moduledoc """
  Define a date_time field.

  #{FormMetal.Fields.Builder.options_doc()}

  ## Example

  ```elixir
  defmodule MyDateTimeField do
    @moduledoc false

    use FormMetal.Fields.DateTimeField

    build_field_type(%{
      uuid: Ecto.UUID.t()
    })

    build_field attrs_changeset: {__MODULE__, :attrs_changeset, []} do
      field :uuid, Ecto.UUID
    end

    @spec attrs_changeset(struct(), map()) :: Ecto.Changeset.t()
    def attrs_changeset(field, params) do
      field
      |> Ecto.Changeset.cast(params, [:uuid])
      |> Ecto.Changeset.validate_required([:uuid])
    end
  end
  ```
  """

  @behaviour FormMetal.Fields.Builder

  @impl FormMetal.Fields.Builder
  defmacro build_field(params, do: block) do
    import FormMetal.Fields.Field
    flavor = Keyword.get(params, :flavor, :singular)

    [
      prelude(),
      quote location: :keep do
        embedded_schema do
          Module.eval_quoted(__MODULE__, unquote(block))

          embeds_one :settings, Settings, primary_key: false do
            field :type, FormMetal.Fields.EctoTypes.DateTimeValueType
          end
        end

        @impl FormMetal.Fields.Field
        def changeset(field, params) do
          changeset =
            field
            |> Ecto.Changeset.cast(params, [])
            |> Ecto.Changeset.cast_embed(:settings,
              required: true,
              with: fn settings, params ->
                settings
                |> Ecto.Changeset.cast(params, [:type])
                |> Ecto.Changeset.validate_required([:type])
              end
            )

          {module, fun, args} = Keyword.fetch!(unquote(params), :attrs_changeset)
          attrs_changeset = apply(module, fun, [field, params | args])

          Ecto.Changeset.merge(changeset, attrs_changeset)
        end
      end,
      value_type(quote do: NaiveDateTime.t()),
      value_delegation(flavor, :naive_datetime_usec)
    ]
  end

  @doc """
  Define the concrete field type.

  ## Example
      fields_type(%{
        uuid: Ecto.UUID.t()
      })
  """
  @impl FormMetal.Fields.Builder
  defmacro build_field_type({:%{}, _meta, defs}) do
    quote do
      @type t() :: %__MODULE__{
              unquote_splicing(defs),
              settings: %__MODULE__.Settings{
                type: FormMetal.Fields.EctoTypes.DateTimeValueType.t()
              }
            }
    end
  end

  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)
    end
  end
end
