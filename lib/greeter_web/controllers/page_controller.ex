defmodule GreeterWeb.PageController do
  use GreeterWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
