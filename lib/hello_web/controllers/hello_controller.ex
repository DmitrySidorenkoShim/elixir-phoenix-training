defmodule HelloWeb.HelloController do
  use HelloWeb, :controller

  action_fallback HelloWeb.MyFallbackController

  def index(conn, _params) do
    conn
    |> put_layout("admin.html")
    |> put_flash(:info, "Welcome to Phoenix, from flash info!")
    |> put_flash(:error, "Let's pretend we have an error.")
    |> render("index.html")
  end

  def show(conn, %{"messenger" => messenger}) do
    render(conn, "show.html", messenger: messenger)
  end

  def test(conn, %{"id" => id}) do
    pages = [%{title: "foo"}, %{id: id}]

    render(conn, "index.json", pages: pages)
  end
end
