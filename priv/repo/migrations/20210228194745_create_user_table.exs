defmodule Rocketpay.Repo.Migrations.CreateUserTable do
  use Ecto.Migration

  # o que é colocado dentro do change ja deixa pronto para
  # criar e tbm para dar rollback
  def change do
    create table :users do
      add :name, :string
      add :age, :integer
      add :email, :string
      add :password_hash, :string
      add :nickname, :string

      timestamps()
    end

    #criando um index unico
    create unique_index(:users, [:email])
    create unique_index(:users, [:nickname])

  end

  # def up do
  #   drop table :users
  # end
end
