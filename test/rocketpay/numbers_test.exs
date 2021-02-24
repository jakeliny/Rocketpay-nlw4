defmodule Rocketpay.NumbersTest do
  # Essa linha diz que esse modulo é um test
  use ExUnit.Case

  alias Rocketpay.Numbers

  # colocamos no describe o nume da função que vamos testar
  # /quantos parametros ela espera
  describe "sum_from_file/1" do
    #Criamos um test, mesma coisa do I do mocha
    test "When there is a file with the given name, returns numbers num" do

      #Criamos uma response que vai chamar nosso modulo
      response = Numbers.sum_from_file("numbers")

      expected_response = {:ok, %{result: 37}}

      #o assert que vai verificar o teste
      assert response == expected_response

    end

    test "When there isn't file with the given name, returns an error" do

      response = Numbers.sum_from_file("banana")

      expected_response = {:error, "Invalid File"}

      assert response == expected_response

    end

  end

end
