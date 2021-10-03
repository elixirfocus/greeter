defmodule GreeterWeb.WelcomeController do
  use GreeterWeb, :controller

  def index(conn, params) do
    name = params["name"]
    formatted_name = Greeter.NameFormatter.format(name)
    render(conn, "index.html", name: formatted_name)
  end
end
