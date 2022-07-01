defmodule FormMetal.Filters.BooleanTest do
  use FormMetal.FilterCase, async: true

  describe "InMemory tester" do
    test "is" do
      assert_in_memory_pairs(FormMetal.Filters.Boolean.Is, [
        {[true, true], true},
        {[true, false], false},
        {[true, nil], false},
        {[false, true], false},
        {[false, false], true},
        {[false, nil], false},
        {[nil, true], false},
        {[nil, false], false},
        {[nil, nil], true}
      ])
    end

    test "is_empty" do
      assert_in_memory_pairs(FormMetal.Filters.String.IsEmpty, [
        {[true], false},
        {[false], false},
        {[nil], true}
      ])
    end

    test "is_true" do
      assert_in_memory_pairs(FormMetal.Filters.Boolean.IsTrue, [
        {[true], true},
        {[false], false},
        {[nil], false}
      ])
    end

    test "is_false" do
      assert_in_memory_pairs(FormMetal.Filters.Boolean.IsFalse, [
        {[true], false},
        {[false], true},
        {[nil], false}
      ])
    end
  end
end
