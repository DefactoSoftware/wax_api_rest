defmodule WaxAPIREST.Types.ServerAuthenticatorAttestationResponseTest do
  use ExUnit.Case, async: true

  alias WaxAPIREST.Types.ServerAuthenticatorAttestationResponse

  @valid_response %{
    "clientDataJSON" => "e30",
    "attestationObject" => "e30"
  }

  test "transports default to the empty list when absent" do
    assert %ServerAuthenticatorAttestationResponse{transports: []} =
             ServerAuthenticatorAttestationResponse.new(@valid_response)
  end

  test "transports nested in the response are parsed" do
    response = Map.put(@valid_response, "transports", ["usb", "hybrid"])

    assert %ServerAuthenticatorAttestationResponse{transports: ["usb", "hybrid"]} =
             ServerAuthenticatorAttestationResponse.new(response)
  end

  test "invalid or unknown transport values are silently dropped" do
    response = Map.put(@valid_response, "transports", ["usb", "carrier-pigeon", 42, "internal"])

    assert %ServerAuthenticatorAttestationResponse{transports: ["usb", "internal"]} =
             ServerAuthenticatorAttestationResponse.new(response)
  end

  test "fallback transports are used when the response doesn't contain them" do
    assert %ServerAuthenticatorAttestationResponse{transports: ["nfc"]} =
             ServerAuthenticatorAttestationResponse.new(@valid_response, ["nfc", "bogus"])
  end

  test "nested transports take precedence over fallback transports" do
    response = Map.put(@valid_response, "transports", ["ble"])

    assert %ServerAuthenticatorAttestationResponse{transports: ["ble"]} =
             ServerAuthenticatorAttestationResponse.new(response, ["nfc"])
  end

  test "non-list transports are ignored" do
    response = Map.put(@valid_response, "transports", "usb")

    assert %ServerAuthenticatorAttestationResponse{transports: []} =
             ServerAuthenticatorAttestationResponse.new(response, "nfc")
  end

  test "a nested null is treated as absent and the fallback transports are used" do
    response = Map.put(@valid_response, "transports", nil)

    assert %ServerAuthenticatorAttestationResponse{transports: ["nfc"]} =
             ServerAuthenticatorAttestationResponse.new(response, ["nfc"])
  end

  test "a nested non-list value wins over valid fallback transports and yields []" do
    response = Map.put(@valid_response, "transports", "usb")

    assert %ServerAuthenticatorAttestationResponse{transports: []} =
             ServerAuthenticatorAttestationResponse.new(response, ["nfc"])
  end
end
