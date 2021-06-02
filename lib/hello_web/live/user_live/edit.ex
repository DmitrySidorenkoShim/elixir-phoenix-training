defmodule HelloWeb.UserLive.Edit do
  use Phoenix.LiveView, layout: {HelloWeb.LayoutView, "live.html"}
  alias HelloWeb.{UserView} # , UserLive
  #alias HelloWeb.Router, as: Routes
  alias Phoenix.LiveView.Socket
  alias Hello.Accounts

  def render(assigns), do: UserView.render("edit.html", assigns)
  def mount(_params, _session, socket), do: {:ok, socket}

  def handle_params(%{"id" => id}, _url, socket) do
    if connected?(socket), do: Accounts.subscribe(id)
    {:noreply, socket |> assign(id: id) |> fetch()}
  end

  defp fetch(%Socket{assigns: %{id: id}} = socket) do
    user = Accounts.get_user!(id)
    cset = Accounts.change_user(user)
    assign(socket, user: user, changeset: cset)
  end

  def handle_info({Accounts, [:user, :updated], _}, socket) do
    {:noreply, fetch(socket)}
  end

  def handle_info({Accounts, [:user, :deleted], _}, socket) do
    {:noreply, push_redirect(socket, to: "/users")}
    #{:noreply, push_redirect(socket, to: Routes.live_path(socket, UserLive.Index))}
  end

  def handle_event("validate", %{"user" => params}, socket) do
    cset = socket.assigns.user
      |> Accounts.change_user(params)
      |> Map.put(:action, :update)
    {:noreply, assign(socket, changeset: cset)}
  end

  def handle_event("save", %{"user" => params}, socket) do
    case Accounts.update_user(socket.assigns.user, params) do
      {:ok, user} ->
        #{:noreply, push_redirect(socket, to: Routes.live_path(socket, UserLive.Show, user))}
        # todo add flash
        {:noreply, push_redirect(socket, to: "/users/#{user.id}")}
      {:error, %Ecto.Changeset{} = cset} ->
        {:noreply, assign(socket, changeset: cset)}
    end
  end
end
