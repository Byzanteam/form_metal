defmodule FormMetal.Filters.Builders.OverlapsBuilder do
  @moduledoc """
  Build a `overlaps` operator for a list filter.
  """

  defmacro __using__(opts) do
    quote location: :keep, bind_quoted: [opts: opts] do
      {:array, singular_value_ecto_type} =
        value_ecto_type = Keyword.fetch!(opts, :value_ecto_type)

      value_type = Keyword.fetch!(opts, :value_type)

      use FormMetal.Filters.Filter

      embedded_schema do
        field :source, value_ecto_type
        field :value, value_ecto_type
      end

      @type t() :: %__MODULE__{
              source: maybe(unquote(value_type)),
              value: maybe(unquote(value_type))
            }

      defimpl FormMetal.Filters.Testers.InMemory do
        import FormMetal.Filters.Builders.InMemoryUtils

        @spec test(%@for{}) :: boolean()
        def test(filter) do
          nil_guard(filter) do
            Enum.any?(filter.source, fn source ->
              Enum.any?(filter.value, fn value ->
                Ecto.Type.equal?(unquote(singular_value_ecto_type), source, value)
              end)
            end)
          end
        end
      end
    end
  end
end
