defmodule WaxAPIREST.Types.ServerAuthenticatorAttestationResponse do
  @moduledoc """
  The authenticator attestation response of the attestation result request

  ## Transports

  The optional `"transports"` field is the value of the client's
  `AuthenticatorAttestationResponse.getTransports()` call. It is accepted both:
  - nested under the `"response"` object (FIDO server API shape)
  - at the top level of the request body

  A present, non-null nested value always wins: if it is a list, it is used (even
  when a top-level field is also present), and if it is not a list, `transports`
  is the empty list. A nested `null` is treated as absent, in which case the
  top-level field is used. Since transports are a mere hint from the client,
  invalid or unknown values are silently dropped instead of being rejected. When
  neither field carries a list, `transports` defaults to the empty list.
  """

  alias WaxAPIREST.Types.{
    AuthenticatorTransport,
    Error
  }

  @enforce_keys [:clientDataJSON, :attestationObject]

  defstruct [
    :clientDataJSON,
    :attestationObject,
    transports: []
  ]

  @type t :: %__MODULE__{
    clientDataJSON: String.t(),
    attestationObject: String.t(),
    transports: [AuthenticatorTransport.t()]
  }

  @spec new(map(), [String.t()] | any()) :: t() | no_return()
  def new(response, fallback_transports \\ nil)

  def new(%{
    "clientDataJSON" => clientDataJSON,
    "attestationObject" => attestationObject
  } = response, fallback_transports)
  when is_binary(clientDataJSON) and is_binary(attestationObject)
  do
    %__MODULE__{
      clientDataJSON: clientDataJSON,
      attestationObject: attestationObject,
      transports: parse_transports(response["transports"] || fallback_transports)
    }
  end

  def new(response, _fallback_transports) do
    if response["clientDataJSON"] == nil or not is_binary(response["clientDataJSON"]) do
      raise Error.MissingField, field: "clientDataJSON"
    end

    if response["attestationObject"] == nil or not is_binary(response["attestationObject"]) do
      raise Error.MissingField, field: "attestationObject"
    end
  end

  @spec parse_transports(any()) :: [AuthenticatorTransport.t()]
  defp parse_transports(transports) when is_list(transports) do
    for transport <- transports,
        is_binary(transport),
        transport in AuthenticatorTransport.accepted_values() do
      AuthenticatorTransport.new(transport)
    end
  end

  defp parse_transports(_), do: []
end
