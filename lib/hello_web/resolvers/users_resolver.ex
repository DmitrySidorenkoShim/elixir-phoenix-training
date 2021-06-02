defmodule HelloWeb.UsersResolver do
  alias Hello.Accounts

  def all_users(_root, _args, _info) do
    {:ok, Accounts.list_users()}
  end

  def get_user(_root, args, _info) do
    {:ok, Accounts.get_user!(args.id)}
  end

  def create_user(_root, args, _info) do
    # TODO: add detailed error message handling later
    case Accounts.create_user(args) do
      {:ok, created_user} ->
        {:ok, created_user}
      _error ->
        {:error, "Could not create User."}
    end
  end

  def update_user(_root, args, _info) do
    # TODO: add detailed error message handling later
    user = Accounts.get_user!(args.id)
    params = %{name: args.name, is_admin: args.is_admin}
    case Accounts.update_user(user, params) do
      {:ok, updated_user} ->
        {:ok, updated_user}
      _error ->
        {:error, "Could not update User."}
    end
  end

  def delete_user(_root, args, _info) do
    # TODO: add detailed error message handling later
    user = Accounts.get_user!(args.id)
    case Accounts.delete_user(user) do
      {:ok, deleted_user} ->
        {:ok, deleted_user}
      _error ->
        {:error, "Could not delete User."}
    end
  end
end
