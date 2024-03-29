defmodule HelloWeb.UserLive.Show do
  use Phoenix.LiveView, layout: {HelloWeb.LayoutView, "live.html"}
  alias Hello.Accounts
  alias HelloWeb.{UserView} # , UserLive
  #alias HelloWeb.Router, as: Routes
  alias Phoenix.LiveView.Socket

  def render(assigns), do: UserView.render("show.html", assigns)
  def mount(_params, _session, socket), do: {:ok, socket}

  def handle_params(%{"id" => id}, _url, socket) do
    if connected?(socket), do: Accounts.subscribe(id)
    {:noreply, socket |> assign(id: id) |> fetch()}
  end

  defp fetch(%Socket{assigns: %{id: id}} = socket) do
    assign(socket, user: Accounts.get_user!(id))
  end

  def handle_info({Accounts, [:user, :updated], _}, socket) do
    {:noreply, fetch(socket)}
  end

  def handle_info({Accounts, [:user, :deleted], _}, socket) do
    {:noreply, push_redirect(socket, to: "/users")}
    # todo add flash
    #{:noreply, push_redirect(socket, to: Routes.live_path(socket, UserLive.Index))}
  end
end
