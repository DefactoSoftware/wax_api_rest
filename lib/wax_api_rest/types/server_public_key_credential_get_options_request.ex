defmodule WaxAPIREST.Types.ServerPublicKeyCredentialGetOptionsRequest do
  alias  WaxAPIREST.Types.{
    Error,
    UserVerificationRequirement
  }

  defstruct [
    :username,
    :extensions,
    userVerification: "preferred"
  ]

  @typedoc """
  The `username` field is optional, so that clients performing a usernameless
  (discoverable credential) flow don't have to send a placeholder value. Note that
  this library performs no user handle based credential lookup: credential selection
  remains entirely the responsibility of the `c:WaxAPIREST.Callback.user_keys/1`
  callback (for instance based on the session).
  """
  @type t :: %__MODULE__{
    username: String.t() | nil,
    extensions: %{required(String.t()) => any()},
    userVerification: UserVerificationRequirement.t() | nil
  }

  @spec new(map()) :: t() | no_return()
  def new(request) when is_map(request) do
    username = request["username"]

    if username != nil and not is_binary(username) do
      raise Error.InvalidField,
        field: "username",
        value: username,
        reason: "must be a string"
    end

    userVerification =
      if request["userVerification"] do
        UserVerificationRequirement.new(request["userVerification"])
      else
        UserVerificationRequirement.new("preferred")
      end

    %__MODULE__{
      username: username,
      extensions: request["extensions"] || %{},
      userVerification: userVerification
    }
  end
end
