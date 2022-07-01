defmodule FormMetal.Filters.Filter do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema

      @primary_key false
    end
  end
end
