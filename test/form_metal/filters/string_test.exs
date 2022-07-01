defmodule FormMetal.Filters.StringTest do
  use FormMetal.FilterCase, async: true

  describe "InMemory tester" do
    test "is" do
      assert_in_memory_pairs(FormMetal.Filters.String.Is, [
        {["foo", "foo"], true},
        {["foo", "bar"], false},
        {["foo", nil], false},
        {[nil, "foo"], false},
        {[nil, nil], true}
      ])
    end

    test "is_empty" do
      assert_in_memory_pairs(FormMetal.Filters.String.IsEmpty, [
        {["foo"], false},
        {[nil], true}
      ])
    end

    test "contains" do
      assert_in_memory_pairs(FormMetal.Filters.String.Contains, [
        {["foobar", "foo"], true},
        {["foo", "foobar"], false},
        {["foo", nil], false},
        {[nil, "foo"], false},
        {[nil, nil], false}
      ])
    end
  end
end
