defmodule Rocketpay.Users.Create do
  alias Rockeatpay.{Repo, User}

  def call(params) do
    params
    |> User.changeset()
    |> Repo.insert()
  end
end
