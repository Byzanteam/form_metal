defmodule FormMetal.Fields.MultipleLineField do
  @moduledoc """
  Define a multiple_line field.

  #{FormMetal.Fields.Builder.options_doc()}
  * `:value_module` - the ecto value module to use for the field value.

  ## Example

  ```elixir
  defmodule MyMultipleLineField do
    @moduledoc false

    use FormMetal.Fields.MultipleLineField

    build_field_type(%{
      uuid: Ecto.UUID.t()
    })

    build_field(
      attrs_changeset: {__MODULE__, :attrs_changeset, []},
      value_module: MyRichText
    ) do
      field :uuid, Ecto.UUID
    end

    @spec attrs_changeset(struct(), map()) :: Ecto.Changeset.t()
    def attrs_changeset(field, params) do
      field
      |> Ecto.Changeset.cast(params, [:uuid])
      |> Ecto.Changeset.validate_required([:uuid])
    end

    @impl true
    def plain_text(_field, value) do
      MyRichText.to_text(value)
    end
  end
  ```
  """

  @behaviour FormMetal.Fields.Builder

  @impl FormMetal.Fields.Builder
  defmacro build_field(params, do: block) do
    import FormMetal.Fields.Field
    value_module = params |> Keyword.fetch!(:value_module) |> Macro.expand(__CALLER__)
    flavor = Keyword.get(params, :flavor, :singular)

    ensure_type_module!(value_module)

    [
      prelude(),
      quote location: :keep do
        embedded_schema do
          Module.eval_quoted(__MODULE__, unquote(block))
        end

        @impl FormMetal.Fields.Field
        def changeset(field, params) do
          {module, fun, args} = Keyword.fetch!(unquote(params), :attrs_changeset)

          apply(module, fun, [field, params | args])
        end
      end,
      value_type(flavor, quote(do: unquote(value_module).t())),
      value_delegation(flavor, value_module)
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
              unquote_splicing(defs)
            }
    end
  end

  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)

      @behaviour unquote(__MODULE__)
    end
  end

  @doc "Extract plain text from the field value."
  @callback plain_text(FormMetal.Fields.Field.field(), FormMetal.Fields.Field.value()) ::
              String.t() | nil
end
