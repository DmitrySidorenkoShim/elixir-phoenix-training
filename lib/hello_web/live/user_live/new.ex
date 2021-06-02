defmodule HelloWeb.UserLive.New do
  use Phoenix.LiveView, layout: {HelloWeb.LayoutView, "live.html"}
  alias Hello.Accounts
  alias Accounts.User
  alias HelloWeb.{UserView} # , UserLive
  #alias HelloWeb.Router, as: Routes

  def render(assigns) do
    UserView.render("new.html", assigns)
  end

  def mount(_params, _session, socket) do
    cset = Accounts.change_user(%User{})
    {:ok, assign(socket, changeset: cset)}
  end

  def handle_event("validate", %{"user" => params}, socket) do
    cset = %User{}
      |> Accounts.change_user(params)
      |> Map.put(:action, :insert)
    {:noreply, assign(socket, changeset: cset)}
  end

  def handle_event("save", %{"user" => params}, socket) do
    case Accounts.create_user(params) do
      {:ok, user} ->
        #{:noreply, push_redirect(socket, to: Routes.live_path(socket, UserLive.Show, user))}
        # todo add flash
        {:noreply, push_redirect(socket, to: "/users/#{user.id}")}
      {:error, %Ecto.Changeset{} = cset} ->
        {:noreply, assign(socket, changeset: cset)}
    end
  end
end
