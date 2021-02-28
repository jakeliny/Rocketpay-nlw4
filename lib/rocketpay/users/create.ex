defmodule Rocketpay.Users.Create do

  alias Ecto.Multi
  alias Rocketpay.{User, Account, Repo}

  def call(params) do
    #criando uma multi operação
    Multi.new()
      # começando com o insert do usuario, o primeiro parametro
      # é o nome dessa operação e depois chamando a operação
    |> Multi.insert(:create_user, User.changeset(params))
    # run permite que façamos uma operação no banco com o repo
    #  e posso ler o resultado da operação anterior pelo nome dela
    # --
    # o segundo parametro é uma função anonima que recebe repo
    # e recebe o resultado da função anterior
    |> Multi.run(:create_account, fn repo, %{create_user: user} ->
      insert_account(repo, user)
    end)
    # para retornar por ultimo um usuario com uma conta e não
    # so a conta (que é o retorno do multi de cima) vamos fazer um pre-load
    |> Multi.run(:preload_data, fn repo, %{create_user: user} ->
      preload_data(repo, user)
    end)
    #A função Multi náo executa, tudo ate aqui foi preparar para rodar as operações
    # Então chamamos essa função para fazer isso
    |> run_transaction()
  end

  defp insert_account(repo, user) do
    user.id
    |> account_changeset()
    |> repo.insert()
  end

  defp account_changeset(user_id) do
    params = %{user_id: user_id, balance: "0.00"}

    Account.changeset(params)
  end

  defp run_transaction(multi) do
    # case é como um swith
    case Repo.transaction(multi) do
      #se receber um erro ele retorna o erro
      {:error, _operation, reason, _changes} -> {:error, reason}
      #
      {:ok, %{preload_data: user}} -> {:ok, user}
      # o default do case seria:
      # _ ->
    end
  end

  defp preload_data(repo, user) do
    #devolvendo um usuario com a conta ja carregada
    {:ok, repo.preload(user, :account)}
  end
end
