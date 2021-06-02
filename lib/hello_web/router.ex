defmodule HelloWeb.Router do
  use HelloWeb, :router
  import Phoenix.LiveView.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug HelloWeb.Plugs.Locale, "en"
    plug :put_root_layout, {HelloWeb.LayoutView, :root}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :is_admin do
    plug HelloWeb.Plugs.IsAdmin
  end

  scope "/admin", HelloWeb.Admin, as: :admin do
    pipe_through :browser
  end

  # Other scopes may use custom stacks.
   scope "/api", HelloWeb, as: :api do
     pipe_through :api

     get "/test/:id", HelloController, :test
   end

  # Other scopes may use custom stacks.
  scope "/api" do
    pipe_through :api

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: HelloWeb.Schema,
      interface: :simple,
      context: %{pubsub: HelloWeb.Endpoint}
  end

  # Our pipeline implements "maybe" authenticated.
  # We'll use the `:ensure_auth` below for when we need to make sure someone is logged in.
  pipeline :auth do
    plug Hello.UserManager.Pipeline
    plug :put_user_token
  end

  # We use ensure_auth to fail if there is no one logged in
  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
    plug :put_user_token
  end

  defp put_user_token(conn, _) do
    if current_user = conn.assigns[:current_user] do
      token = Phoenix.Token.sign(conn, "user socket", current_user.id)
      assign(conn, :user_token, token)
    else
      conn
    end
  end

  # Maybe logged in routes
  scope "/", HelloWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :index
    get "/page", PageController, :show
    get "/pages", PageController, :pages

    live "/auction", AuctionLive
    live "/clock", ClockLive

    get "/login", SessionController, :new
    post "/login", SessionController, :login
    get "/logout", SessionController, :logout
  end

  # Definitely logged in scope
  scope "/", HelloWeb do
    pipe_through [:browser, :auth, :ensure_auth]

    get "/protected", PageController, :protected
  end

  # Definitely logged in scope
  scope "/", HelloWeb do
    pipe_through [:browser, :auth, :ensure_auth, :is_admin]

    live "/users", UserLive.Index
    live "/users/new", UserLive.New
    live "/users/:id", UserLive.Show
    live "/users/:id/edit", UserLive.Edit

    #resources "/users", UserController
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: HelloWeb.Telemetry
    end
  end
end
