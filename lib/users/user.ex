defmodule Flightex.Users.User do
  @keys [:name, :email, :cpf, :id]
  @enforce_keys @keys
  defstruct @keys

  def build(_name, _email, cpf) when not is_bitstring(cpf) do
    {:error, "Cpf must be a String"}
  end

  def build(name, email, cpf) do
    uuid = UUID.uuid4()

    user = %__MODULE__{
      name: name,
      email: email,
      cpf: cpf,
      id: uuid
    }

    {:ok, user}
  end
end
