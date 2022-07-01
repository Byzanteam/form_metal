# credo:disable-for-this-file Credo.Check.Refactor.ModuleDependencies
defmodule FormMetal.Filters.Builders.ListBuilder do
  @moduledoc """
  Build `list` operators for the value.
  """

  defmacro __using__(opts) do
    operator = Keyword.fetch!(opts, :operator)
    singular_filters = Keyword.fetch!(opts, :singular_filters)

    Enum.flat_map(singular_filters, fn singular_filter ->
      singular_filter = Macro.expand(singular_filter, __CALLER__)

      Code.ensure_compiled!(singular_filter)

      name = singular_filter |> Module.split() |> List.last() |> String.to_existing_atom()
      # credo:disable-for-next-line Credo.Check.Warning.UnsafeToAtom
      module_name = Module.concat(__CALLER__.module, name)

      fields =
        Enum.map(singular_filter.__schema__(:fields), fn field ->
          {field, singular_filter.__schema__(:type, field)}
        end)

      t_typespec =
        case Code.Typespec.fetch_types(singular_filter) do
          :error ->
            raise ArgumentError,
                  "No type information for the singular filter: `#{inspect(singular_filter)}`"

          {:ok, types} ->
            types
            |> Enum.find(&match?({:type, {:t, _meta, []}}, &1))
            # credo:disable-for-next-line Credo.Check.Refactor.Nesting
            |> case do
              nil ->
                raise ArgumentError,
                      "No type information for `#{inspect(singular_filter)}.t()` was found or `#{inspect(singular_filter)}.t()` is private."

              {:type, typespec} ->
                typespec
            end
        end

      t_type_def = make_t_type(t_typespec, {singular_filter, module_name})

      module =
        quote location: :keep,
              bind_quoted: [
                module_name: module_name,
                fields: fields,
                t_type_def: t_type_def
              ] do
          defmodule module_name do
            use FormMetal.Filters.Filter

            embedded_schema do
              Enum.each(fields, fn
                {:source, type} ->
                  field :source, {:array, type}

                {name, type} ->
                  field name, type
              end)
            end

            @type unquote(t_type_def)
          end
        end

      implement =
        quote location: :keep,
              bind_quoted: [
                operator: operator,
                singular_filter: singular_filter,
                module_name: module_name
              ] do
          defimpl FormMetal.Filters.Testers.InMemory, for: module_name do
            alias FormMetal.Filters.Builders.InMemoryUtils

            @spec test(%@for{}) :: boolean()
            def test(filter) do
              InMemoryUtils.list_test(unquote(operator), filter, unquote(singular_filter))
            end
          end
        end

      [module, implement]
    end)
  end

  defp make_t_type(type_def, {singular_filter_module, list_filter_module}) do
    type_def
    |> Code.Typespec.type_to_quoted()
    |> Macro.prewalk(fn
      ^singular_filter_module ->
        list_filter_module

      {:source, source_ast} ->
        {:source, quote(do: maybe([unquote(source_ast)]))}

      other ->
        other
    end)
    |> Macro.escape()
  end
end
