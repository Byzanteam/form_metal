defmodule FormMetal.Fields.Builder do
  @moduledoc """
  Define Field builder contract.
  """

  @doc """
  The callback invoked to build a field.
  """
  @macrocallback build_field(Keyword.t(), do: Macro.t()) :: Macro.t()

  @doc """
  The callback invoked to build the type for a field.
  """
  @macrocallback build_field_type(Macro.t()) :: Macro.t()

  @spec options_doc() :: String.t()
  def options_doc do
    """
    ## Options

      * `:attrs_changeset` - the function to build the changeset from params.
        It can be changed by passing an MFA tuple. The field schema
        and parameters arguments will be prepended to the given args. For example,
        using `with: {Author, :attrs_changeset, ["hello"]}` will be invoked as
        `Author.attrs_changeset(schema, params, "hello")`
    """
  end
end
