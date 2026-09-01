defmodule WaxAPIREST.Types.AuthenticatorSelectionCriteria do
  alias WaxAPIREST.Types.{
    AuthenticatorAttachment,
    ResidentKeyRequirement,
    UserVerificationRequirement
  }

  defstruct [
    :authenticatorAttachment,
    :residentKey,
    requireResidentKey: false,
    userVerification: "preferred"
  ]

  @type t :: %__MODULE__{
    authenticatorAttachment: AuthenticatorAttachment.t() | nil,
    requireResidentKey: boolean(),
    residentKey: ResidentKeyRequirement.t() | nil,
    userVerification: UserVerificationRequirement.t() | nil
  }

  @doc """
  Normalizes an authenticator selection value to a `t:t/0` struct

  Accepts a `t:t/0` struct (returned as-is), a map with string keys, or `nil`.
  """
  @spec normalize(t() | map() | nil) :: t() | nil
  def normalize(nil), do: nil
  def normalize(%__MODULE__{} = criteria), do: criteria
  def normalize(%{} = data), do: new(data)

  @spec new(map()) :: t()
  def new(data) do
    %__MODULE__{
      authenticatorAttachment: (if data["authenticatorAttachment"], do: AuthenticatorAttachment.new(data["authenticatorAttachment"])),
      requireResidentKey: data["requireResidentKey"],
      residentKey: (if data["residentKey"], do: ResidentKeyRequirement.new(data["residentKey"])),
      userVerification: (if data["userVerification"], do: UserVerificationRequirement.new(data["userVerification"]))
    }
  end
end
