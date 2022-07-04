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

  describe "InMemory tester for list values" do
    test "all is" do
      assert_in_memory_pairs(FormMetal.Filters.String.List.All.Is, [
        {[["foo"], "foo"], true},
        {[["foo", "foo"], "foo"], true},
        {[["foo", "bar"], "foo"], false},
        {[["foo", nil], "foo"], false},
        {[[nil], nil], false},
        {[nil, "foo"], false},
        {[nil, nil], false}
      ])
    end

    test "any is" do
      assert_in_memory_pairs(FormMetal.Filters.String.List.Any.Is, [
        {[["foo"], "foo"], true},
        {[["foo", "foo"], "foo"], true},
        {[["foo", "bar"], "foo"], true},
        {[["foo", nil], "foo"], true},
        {[[nil], nil], false},
        {[nil, "foo"], false},
        {[nil, nil], false}
      ])
    end

    test "all is_empty" do
      assert_in_memory_pairs(FormMetal.Filters.String.List.All.IsEmpty, [
        {[["foo"]], false},
        {[["foo", nil]], false},
        {[[nil, nil]], true},
        {[nil], false}
      ])
    end

    test "any is_empty" do
      assert_in_memory_pairs(FormMetal.Filters.String.List.Any.IsEmpty, [
        {[["foo"]], false},
        {[["foo", nil]], true},
        {[[nil, nil]], true},
        {[nil], false}
      ])
    end

    test "all contains" do
      assert_in_memory_pairs(FormMetal.Filters.String.List.All.Contains, [
        {[["foobar"], "foo"], true},
        {[["foobar", "foo"], "foobar"], false},
        {[["foo"], nil], false},
        {[[nil], "foo"], false},
        {[nil, nil], false}
      ])
    end

    test "any contains" do
      assert_in_memory_pairs(FormMetal.Filters.String.List.Any.Contains, [
        {[["foobar"], "foo"], true},
        {[["foobar", "foo"], "foobar"], true},
        {[["foo"], nil], false},
        {[[nil], "foo"], false},
        {[nil, nil], false}
      ])
    end
  end
end
