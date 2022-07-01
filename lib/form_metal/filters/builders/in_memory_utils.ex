defmodule FormMetal.Filters.Builders.InMemoryUtils do
  @moduledoc false

  @doc """
  Add `not_nil` filter to the block.

  ## Example:

  ```
  nil_guard(filter) do
    ms_source = MapSet.new(source)
    ms_value = MapSet.new(value)

    MapSet.subset?(ms_value, ms_source)
  end
  ```
  """
  defmacro nil_guard(filter, do: block) do
    quote do
      if unquote(__MODULE__).any_is_nil?(unquote(filter)) do
        false
      else
        unquote(block)
      end
    end
  end

  @spec any_is_nil?(struct()) :: boolean()
  def any_is_nil?(filter) do
    fields = filter.__struct__.__schema__(:fields)

    Enum.any?(fields, fn field ->
      is_nil(Map.fetch!(filter, field))
    end)
  end

  @spec list_test(operator :: atom(), struct(), module()) :: boolean()
  def list_test(operator, filter, singular_filter_module) do
    alias FormMetal.Filters.Testers.InMemory

    nil_guard(filter) do
      params = Map.from_struct(filter)

      fun = get_list_test_function(operator)

      fun.(
        filter.source,
        fn source ->
          params = Map.put(params, :source, source)
          singular_filter = struct!(singular_filter_module, params)

          InMemory.test(singular_filter)
        end
      )
    end
  end

  defp get_list_test_function(:all), do: &Enum.all?/2
  defp get_list_test_function(:any), do: &Enum.any?/2
end
