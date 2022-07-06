defmodule FormMetal.Fields.Field do
  @moduledoc """
  Defines `FormMetal.Fields.Field` contract.
  """

  @type field() :: Ecto.Schema.embedded_schema()
  @type value() :: term()

  @doc "Make a field change."
  @callback changeset(field, params :: map()) :: Ecto.Changeset.t(field) when field: field()

  @callback cast_value(field(), value()) :: {:ok, term()} | :error
  @callback load_value(field(), value()) :: {:ok, term()} | :error
  @callback dump_value(field(), value()) :: {:ok, term()} | :error

  @doc "The field prelude that adds preset configuration to the field."
  @spec prelude() :: Macro.t()
  def prelude do
    quote do
      use Ecto.Schema

      @primary_key false
      @timestamps_opts [type: :naive_datetime_usec]

      @before_compile FormMetal.Fields.Field
      @behaviour FormMetal.Fields.Field
      @defoverridable FormMetal.Fields.Field
    end
  end

  @spec value_delegation(flavor :: :singular | :list, Ecto.Type.t()) :: Macro.t()
  def value_delegation(flavor \\ :singular, value_type) do
    value_type =
      case flavor do
        :singular -> value_type
        :list -> {:array, value_type}
      end

    quote do
      alias FormMetal.Values.Value

      @impl FormMetal.Fields.Field
      def cast_value(_field, value) do
        Value.cast(unquote(value_type), value)
      end

      @impl FormMetal.Fields.Field
      def load_value(_field, value) do
        Value.load(unquote(value_type), value)
      end

      @impl FormMetal.Fields.Field
      def dump_value(_field, value) do
        Value.dump(unquote(value_type), value)
      end
    end
  end

  @spec value_type(flavor :: :singular | :list, Macro.t()) :: Macro.t()
  def value_type(flavor \\ :singular, value_type) do
    case flavor do
      :singular ->
        quote do
          @type value() :: unquote(value_type) | nil
        end

      :list ->
        quote do
          @type value() :: [unquote(value_type) | nil] | nil
        end
    end
  end

  @spec ensure_type_module!(Ecto.Type.t()) :: no_return()
  def ensure_type_module!(mod) do
    unless Code.ensure_loaded?(mod) && function_exported?(mod, :type, 0) do
      raise ArgumentError, "invalid or unknown type `#{inspect(mod)}`."
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
