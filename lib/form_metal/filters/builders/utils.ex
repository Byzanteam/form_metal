defmodule FormMetal.Filters.Builders.Utils do
  @moduledoc false

  @doc """
  Add not_nil filter to expr.

  ## Example:

  ```
  filter_not_nil(true or false)

  # or

  filter_not_nil do
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
end
