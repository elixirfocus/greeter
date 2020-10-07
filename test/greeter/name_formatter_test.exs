defmodule Greeter.NameFormatterTest do
  use ExUnit.Case, async: true

  alias Greeter.NameFormatter

  describe "format/1" do
    test "works with simple name" do
      assert NameFormatter.format("mike") == "Mike"
    end
  end
end
