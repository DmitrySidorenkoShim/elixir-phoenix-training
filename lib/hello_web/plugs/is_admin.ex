defmodule HelloWeb.Plugs.IsAdmin do
  use HelloWeb, :controller

  def init(default), do: default

  def call(conn, _default) do
    # get auth user
    case Guardian.Plug.current_resource(conn) do
      nil ->
        # return error and redirect to protected if no auth user
        conn
        |> put_flash(:error, "Only for auth users which are Admins.")
        |> redirect(to: "/protected")
        |> halt()
      current_user ->
        is_admin = current_user.is_admin
        #IO.inspect is_admin
        if is_admin do
          conn
        else
          # return error and redirect to protected if the user is not Admin
          conn
          |> put_flash(:error, "Only for Admins.")
          |> redirect(to: "/protected")
          |> halt()
        end
    end
  end
end
