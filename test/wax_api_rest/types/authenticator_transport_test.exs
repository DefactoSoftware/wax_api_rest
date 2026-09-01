defmodule WaxAPIREST.Types.AuthenticatorTransportTest do
  use ExUnit.Case, async: true

  alias WaxAPIREST.Types.AuthenticatorTransport
  alias WaxAPIREST.Types.Error

  test "accepted transport values are returned verbatim" do
    for transport <- ["usb", "nfc", "ble", "smart-card", "hybrid", "internal", "lightning"] do
      assert AuthenticatorTransport.new(transport) == transport
    end
  end

  test "unknown transport values raise InvalidField" do
    assert_raise Error.InvalidField, fn ->
      AuthenticatorTransport.new("carrier-pigeon")
    end
  end

  test "accepted_values/0 returns the full accepted set" do
    assert AuthenticatorTransport.accepted_values() == [
             "usb",
             "nfc",
             "ble",
             "smart-card",
             "hybrid",
             "internal",
             "lightning"
           ]
  end
end
