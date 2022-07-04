# credo:disable-for-this-file Credo.Check.Refactor.ModuleDependencies
defmodule FormMetal.Filters.Builders.ListBuilder do
  @moduledoc """
  Build `list` operators for the value.
  """

  defmacro __using__(opts) do
    opts
    |> Keyword.fetch!(:operators)
    |> Macro.expand(__CALLER__)
    |> Enum.map(fn
      :all ->
        Module.put_attribute(__CALLER__.module, :after_compile, {__MODULE__, :build_all_operator})

      :any ->
        Module.put_attribute(__CALLER__.module, :after_compile, {__MODULE__, :build_any_operator})
    end)
  end

  @spec build_any_operator(Macro.Env.t(), binary()) :: term()
  def build_any_operator(env, bytecode) do
    do_build(:any, env, bytecode)
  end

  @spec build_all_operator(Macro.Env.t(), binary()) :: term()
  def build_all_operator(env, bytecode) do
    do_build(:all, env, bytecode)
  end

  defp do_build(operator, env, bytecode) when operator in [:all, :any] do
    singular_filter_module = env.module
    list_filter_module = build_list_filter_name(env, operator)

    fields =
      Enum.map(singular_filter_module.__schema__(:fields), fn field ->
        {field, singular_filter_module.__schema__(:type, field)}
      end)

    t_type_def =
      case fetch_t_typespec(bytecode) do
        {:ok, typespec} ->
          make_t_type(typespec, {singular_filter_module, list_filter_module})

        :error ->
          raise ArgumentError,
                "No type information for `#{inspect(singular_filter_module)}.t()` was found or `#{inspect(singular_filter_module)}.t()` is private."
      end

    contents =
      quote location: :keep,
            bind_quoted: [
              singular_filter_module: singular_filter_module,
              list_filter_module: list_filter_module,
              fields: fields,
              operator: operator,
              t_type_def: t_type_def
            ] do
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

        # the in_memory tester implement
        defimpl FormMetal.Filters.Testers.InMemory, for: list_filter_module do
          alias FormMetal.Filters.Builders.InMemoryUtils

          @spec test(%@for{}) :: boolean()
          def test(filter) do
            InMemoryUtils.list_test(unquote(operator), filter, unquote(singular_filter_module))
          end
        end
      end

    Module.create(list_filter_module, contents, Macro.Env.location(__ENV__))
  end

  defp build_list_filter_name(env, operator) do
    names =
      env.module
      |> Module.split()
      |> List.insert_at(-2, "List")
      |> List.insert_at(-2, operator |> Atom.to_string() |> Macro.camelize())

    # credo:disable-for-next-line Credo.Check.Warning.UnsafeToAtom
    Module.concat(names)
  end

  defp fetch_t_typespec(bytecode) do
    case Code.Typespec.fetch_types(bytecode) do
      :error ->
        :error

      {:ok, types} ->
        types
        |> Enum.find(&match?({:type, {:t, _meta, []}}, &1))
        # credo:disable-for-next-line Credo.Check.Refactor.Nesting
        |> case do
          nil ->
            :error

          {:type, typespec} ->
            {:ok, typespec}
        end
    end
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
