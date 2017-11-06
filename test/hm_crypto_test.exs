defmodule HmCryptoTest do
  use ExUnit.Case
  doctest HmCrypto

  test "greets the world" do
    assert HmCrypto.hello() == :world
  end
end
