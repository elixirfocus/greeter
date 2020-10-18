defmodule Greeter.NameFormatterTest do
  use ExUnit.Case, async: true

  describe "format/1" do
    test "works with simple name" do
      assert Greeter.NameFormatter.format("mike") == "Mike"
    end
  end
end
