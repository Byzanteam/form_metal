defmodule FormMetal.Fields.SingleLineField do
  @moduledoc """
  Define a single_line field.

  ## Options

    * `:attrs_changeset` - the function to build the changeset from params.
      It can be changed by passing an MFA tuple. The field schema
      and parameters arguments will be prepended to the given args. For example,
      using `with: {Author, :attrs_changeset, ["hello"]}` will be invoked as
      `Author.attrs_changeset(schema, params, "hello")`

  ## Example

  ```elixir
  defmodule MySingleLineField do
    @moduledoc false

    use FormMetal.Fields.SingleLineField

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
    alias FormMetal.Fields.Field

    [
      Field.prelude(),
      quote location: :keep do
        embedded_schema do
          Module.eval_quoted(__MODULE__, unquote(block))
        end

        @impl FormMetal.Fields.Field
        def changeset(field, params) do
          {module, fun, args} = Keyword.fetch!(unquote(params), :attrs_changeset)
          apply(module, fun, [field, params | args])
        end
      end
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
    end
  end
end
