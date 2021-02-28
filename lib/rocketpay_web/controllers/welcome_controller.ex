# Como o arquivo é .ex criando um modulo seguindo
# o contexto que ele está: RocketpayWeb
defmodule RocketpayWeb.WelcomeController do

  #Crianod um alias
  alias Rocketpay.Numbers

  # Como esse modulo é especial por ser um controller
  # Definimos isso com:
  use RocketpayWeb, :controller

  # Toda função dentro de controller recebe dois parametros
  # conexão e parametros
  # Como nossa função é get vamos usar o _(underline) para ignorar o params
  def index(conn, _params) do

    # conn é uma structe e sempre estareos enviando e recebendo a conn
    text(conn, "Hello Word")
  end

    #Pegando filename que vem na rota e por pattern match
    #estou falando que se existir um paremetro filename
    #ele vai atribuir a uma variavell chamada filenameParam
  def sumFile(conn, %{"filename" => filenameParam}) do
    filenameParam
    |> Numbers.sum_from_file()
    |> handle_response(conn) #No controller sempre devemos manejar o conn
  end

  defp handle_response({:ok, %{result: result}}, conn) do
    conn
    |> put_status(:ok) # definindo o status de conn
    |> json(%{message: "Here is your number: #{result}"})
  end

  defp handle_response({:error, reason}, conn) do
    conn
    |> put_status(:bad_request)
    |> json(%{message: reason})
  end

end
