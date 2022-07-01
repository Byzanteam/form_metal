defprotocol FormMetal.Filters.Testers.InMemory do
  @moduledoc """
  The InMemory tester.
  """

  @spec test(t()) :: boolean()
  def test(filter)
end
