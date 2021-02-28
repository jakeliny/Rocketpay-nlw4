defmodule Rocketpay do

  alias Rocketpay.Users.Create, as: UserCreate

    # passando params para o metodo call de users.create
    defdelegate create_user(params), to: UserCreate, as: :call
end
