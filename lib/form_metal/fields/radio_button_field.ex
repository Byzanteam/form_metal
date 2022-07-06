defmodule FormMetal.Fields.RadioButtonField do
  @moduledoc """
  Define a radio_button field.

  #{FormMetal.Fields.Builder.options_doc()}

  ## Example

  ```elixir
  defmodule MyRadioButtonField do
    @moduledoc false

    use FormMetal.Fields.RadioButtonField

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
            field :options, {:array, :string}
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
                |> Ecto.Changeset.cast(params, [:options], empty_values: [[]])
                |> Ecto.Changeset.validate_required([:options])
              end
            )

          {module, fun, args} = Keyword.fetch!(unquote(params), :attrs_changeset)
          attrs_changeset = apply(module, fun, [field, params | args])

          Ecto.Changeset.merge(changeset, attrs_changeset)
        end
      end,
      value_type(flavor, quote(do: String.t())),
      value_delegation(flavor, :string)
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
                options: [String.t(), ...]
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
