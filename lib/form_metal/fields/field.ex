defmodule FormMetal.Fields.Field do
  @moduledoc """
  Defines `FormMetal.Fields.Field` contract.
  """

  @type field() :: Ecto.Schema.embedded_schema()
  @type value() :: term()

  @doc "Make a field change."
  @callback changeset(field, params :: map()) :: Ecto.Changeset.t(field) when field: field()

  @doc "Resolve ecto value type"
  @callback ecto_value_type() :: Ecto.Type.t()

  @doc "The field prelude that adds preset configuration to the field."
  @spec prelude() :: Macro.t()
  def prelude do
    quote do
      use Ecto.Schema

      @typep maybe(t) :: FormMetal.Types.maybe(t)

      @primary_key false
      @timestamps_opts [type: :naive_datetime_usec]

      @before_compile FormMetal.Fields.Field
      @behaviour FormMetal.Fields.Field
      @defoverridable FormMetal.Fields.Field
    end
  end

  @spec value_type(flavor :: :singular | :list, Macro.t(), Macro.t()) :: Macro.t()
  def value_type(flavor \\ :singular, value_type, ecto_type) do
    case flavor do
      :singular ->
        quote do
          @type value() :: maybe(unquote(value_type))

          @impl FormMetal.Fields.Field
          def ecto_value_type, do: unquote(ecto_type)
        end

      :list ->
        quote do
          @type value() :: maybe([maybe(unquote(value_type))])

          @impl FormMetal.Fields.Field
          def ecto_value_type, do: {:array, unquote(ecto_type)}
        end
    end
  end

  @spec ensure_type_module!(Ecto.Type.t()) :: term()
  def ensure_type_module!(mod) do
    case Code.ensure_compiled(mod) do
      {:module, _module} ->
        unless function_exported?(mod, :type, 0) do
          raise ArgumentError, "unknown type `#{inspect(mod)}`."
        end

      {:error, reason} ->
        raise ArgumentError, "invalid type `#{inspect(mod)}`, due to #{inspect(reason)}."
    end
  end

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
