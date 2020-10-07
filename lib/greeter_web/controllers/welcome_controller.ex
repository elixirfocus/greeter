defmodule GreeterWeb.WelcomeController do
  use GreeterWeb, :controller

  alias Greeter.NameFormatter

  def index(conn, %{"name" => name}) do
    formatted_name = NameFormatter.format(name)
    render(conn, "index.html", name: formatted_name)
  end
end
