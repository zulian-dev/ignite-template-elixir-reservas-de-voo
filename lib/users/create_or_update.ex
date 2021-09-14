defmodule Flightex.Users.CreateOrUpdate do
  alias Flightex.Users.User
  alias Flightex.Users.Agent, as: UserAgent

  def call(%{
        name: name,
        email: email,
        cpf: cpf
      }) do
    User.build(name, email, cpf)
    |> save_user()
  end

  def save_user({:ok, %User{} = user}) do
    UserAgent.save(user)
  end

  def save_user({:error, _msg} = error) do
    error
  end
end
