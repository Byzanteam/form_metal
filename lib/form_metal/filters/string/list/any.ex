defmodule FormMetal.Filters.String.List.Any do
  @moduledoc false

  use FormMetal.Filters.Builders.ListBuilder,
    operator: :any,
    singular_filters: [
      FormMetal.Filters.String.Is,
      FormMetal.Filters.String.IsEmpty,
      FormMetal.Filters.String.Contains
    ]
end
