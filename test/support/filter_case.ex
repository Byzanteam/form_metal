defmodule FormMetal.FilterCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  using do
    quote do
      import unquote(__MODULE__)
    end
  end

  @spec assert_in_memory_pairs(
          Ecto.Schema.embedded_schema(),
          {values :: [term()], expected :: term()}
        ) ::
          no_return()
  def assert_in_memory_pairs(schema, pairs) do
    alias FormMetal.Filters.Testers.InMemory

    fields = schema.__schema__(:fields)

    Enum.each(pairs, fn {pair, expected} ->
      params = Map.new(Enum.zip(fields, pair))
      filter = struct!(schema, params)

      assert expected === InMemory.test(filter),
             "Expected the test result of #{inspect(filter)} to be #{inspect(expected)}"
    end)
  end
end
