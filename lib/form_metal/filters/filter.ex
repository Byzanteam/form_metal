defmodule FormMetal.Filters.Filter do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema

      @primary_key false

      @before_compile unquote(__MODULE__)

      @typep maybe(t) :: t | nil
    end
  end

  defmacro __before_compile__(env) do
    unless Module.defines_type?(env.module, {:t, 0}) do
      raise ArgumentError, """
      the module #{inspect(env.module)} does not define a `t/0` type.
      """
    end
  end
end
