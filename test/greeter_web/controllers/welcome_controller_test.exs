defmodule GreeterWeb.WelcomeControllerTest do
  use GreeterWeb.ConnCase

  test "GET /welcome/gus", %{conn: conn} do
    conn = get(conn, "/welcome/gus")
    assert html_response(conn, 200) =~ "Welcome, Gus!"
  end
end
