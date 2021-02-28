defmodule Rocketpay.Accounts.Operation do
  alias Ecto.Multi

  alias Rocketpay.{Account, Repo}

  def call(%{"id" => id, "value" => value}, operation) do
    operation_name = account_operation_name(operation)

    Multi.new()
    |> Multi.run(operation_name, fn repo, _changes -> get_account(repo, id) end)
    |> Multi.run(operation, fn repo, changes ->
      account = Map.get(changes, operation_name)

      #para atualizar o saldo da conta
      update_balance(repo, account, value, operation)
    end)
  end

  defp get_account(repo, id) do
    #repo.get buscando a account pelo id
    case repo.get(Account, id) do
      #nil é nullo
      nil -> {:error, "Account not found!"}
      #se encontrar a conta retorna a propria conta
      account -> {:ok, account}
    end
  end

  defp update_balance(repo, account, value, operation) do
    account
    |> operation(value, operation)
    |> update_account(repo, account)
  end

  defp operation(%Account{balance: balance}, value, operation) do
    value
    #Decimal.cast - transforma o valor para decimal
    |> Decimal.cast()
    #se eu receber ok, vamos passar balance e o nome da operação
    |> handle_cast(balance, operation)
  end

  # se é deposito, soma o valor do balance com o valor que veio
  defp handle_cast({:ok, value}, balance, :deposit), do: Decimal.add(balance, value)

  #se é uma retirada, subtrai o valor do balance com o valor que veio
  defp handle_cast({:ok, value}, balance, :withdraw), do: Decimal.sub(balance, value)

  #se der erro, retorna valor de deposito invalido
  defp handle_cast(:error, _balance, _operation), do: {:error, "Invalid deposit value!"}

  # se receber um erro, vai retornar o erro
  defp update_account({:error, _reason} = error, _repo, _account), do: error

  #se receber um valor qualquer e o repo, ele faz o update
  defp update_account(value, repo, account) do
    params = %{balance: value}

    account
    |> Account.changeset(params)
    |> repo.update()
  end

  defp account_operation_name(operation) do
    "account_#{Atom.to_string(operation)}" |> String.to_atom()
  end
end
