defmodule FormMetal.Filters.String.List.All do
  @moduledoc false

  use FormMetal.Filters.Builders.ListBuilder,
    operator: :all,
    singular_filters: [
      FormMetal.Filters.String.Is,
      FormMetal.Filters.String.IsEmpty,
      FormMetal.Filters.String.Contains
    ]
end
