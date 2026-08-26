defmodule WaxAPIREST.Types.AuthenticatorTransport do
  alias WaxAPIREST.Types.Error

  @typedoc """
  Must be one of:
  - `"usb"`
  - `"nfc"`
  - `"ble"`
  - `"smart-card"`
  - `"hybrid"`
  - `"internal"`
  - `"lightning"`
  """
  @type t :: String.t()

  @accepted_values ["usb", "nfc", "ble", "smart-card", "hybrid", "internal", "lightning"]

  @spec new(String.t()) :: t() | no_return()
  def new(val) when val in @accepted_values, do: val
  def new(val), do: raise Error.InvalidField,
                    field: "transports",
                    value: val,
                    accepted_value: @accepted_values

  @doc """
  Returns the list of accepted transport values
  """
  @spec accepted_values() :: [t()]
  def accepted_values(), do: @accepted_values
end
