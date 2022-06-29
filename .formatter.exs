[
  inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"],
  import_deps: [:ecto, :typed_struct],
  export: [
    locals_without_parens: [build_field: 2]
  ]
]
