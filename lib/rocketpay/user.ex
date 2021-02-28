defmodule Rocketpay.User  do

use Ecto.Schema
import Ecto.Changeset

alias Ecto.Changeset

#setando que ira ter um UUID para cada campo
@primary_key{:id, :binary_id, autogenerate: true}
@required_params [:name, :age, :email, :password, :nickname]

  schema "users" do
    field :name, :string
    field :age, :integer
    field :email, :string
    #campo virtual, so existe no schema e não existe no bd
    field :password, :string, virtual: true
    field :password_hash, :string
    field :nickname, :string
    timestamps()
  end

  # estrutura responsavel por validar as entradas para o schema
  def changeset(params) do
    #struct vazia do tipo user
    %__MODULE__{}
    #mapea os dados e inserindo na struct acima
    |> cast(params, @required_params)
    # |> IO.inspect() #funciona como um console log
    #valida os dados que são required
    |> validate_required(@required_params)
    #valida o tamanho do dado da senha
    |> validate_length(:password, min: 6)
    #valida que idade seja maior ou igual a 18
    |> validate_number(:age, greater_than_or_equal_to: 18)
    #validando um email valido
    |> validate_format(:email, ~r/@/)
    #valida que o email inputado é unico
    |> unique_constraint([:email])
    #valida que o nickname é unico
    |> unique_constraint([:nickname])
    # chama a função que vai erncriptar o password
    |> put_password_hash()
  end

  # tem uma chave que ve o match se exist valid: true e password
  defp put_password_hash(%Changeset{
    valid?: true,
    changes: %{password: password}
  } = changeset) do
    #passando changeset para o change e encriptando a password
    change(changeset, Bcrypt.add_hash(password))
  end

  #changeset invalido, devolve changeset invalido
  defp put_password_hash(changeset), do: changeset
end
