defmodule HelloWeb.Schema do
  use Absinthe.Schema

  alias HelloWeb.UsersResolver

  object :user do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :email, non_null(:string)
    field :password, non_null(:string)
    field :is_admin, non_null(:boolean)
  end

  query do
    @desc "Get all Users"
    field :all_users, non_null(list_of(non_null(:user))) do
      resolve(&UsersResolver.all_users/3)
    end

    @desc "Get User"
    field :get_user, :user do
      arg :id, non_null(:integer)

      resolve &UsersResolver.get_user/3
    end
  end

  mutation do
    @desc "Create a new User"
    field :create_user, :user do
      arg :name, non_null(:string)
      arg :email, non_null(:string)
      arg :password, non_null(:string)
      arg :is_admin, non_null(:boolean)

      resolve &UsersResolver.create_user/3
    end

    @desc "Update an existing User"
    field :update_user, :user do
      arg :id, non_null(:integer)
      arg :name, non_null(:string)
      arg :is_admin, non_null(:boolean)

      resolve &UsersResolver.update_user/3
    end

    @desc "Delete the User"
    field :delete_user, :user do
      arg :id, non_null(:integer)

      resolve &UsersResolver.delete_user/3
    end
  end
end
