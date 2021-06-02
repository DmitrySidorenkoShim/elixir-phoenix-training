defmodule HelloWeb.AuctionLive do
  use Phoenix.LiveView, layout: {HelloWeb.LayoutView, "live.html"}

  @topic "auction"

  def mount(_params, _session, socket) do
    HelloWeb.Endpoint.subscribe(@topic)
    {:ok, assign(socket, :raised, 0)}
  end

  def render(assigns) do
    ~L"""
      <h1>LiveView is here:</h1>
      <div id="auction">
        <div class="meter">
          <span style="width: <%= @raised %>%">
            $<%= @raised %> USD
          </span>
        </div>

        <button phx-click="donate-1"> $1 </button>
          <button phx-click="donate-5"> $5 </button>
          <button phx-click="donate-10"> $10 </button>
          <button phx-click="donate-100"> $100 </button>
      </div>
    """
  end

  def handle_event("donate-1", _, socket) do
    raised = socket.assigns.raised + 1
    HelloWeb.Endpoint.broadcast_from(self(), @topic, "donate_event", raised)
    {:noreply, assign(socket, :raised, raised)}
  end

  def handle_event("donate-5", _, socket) do
    raised = socket.assigns.raised + 5
    HelloWeb.Endpoint.broadcast_from(self(), @topic, "donate_event", raised)
    {:noreply, assign(socket, :raised, raised)}
  end

  def handle_event("donate-10", _, socket) do
    raised = socket.assigns.raised + 10
    HelloWeb.Endpoint.broadcast_from(self(), @topic, "donate_event", raised)
    {:noreply, assign(socket, :raised, raised)}
  end

  def handle_event("donate-100", _, socket) do
    raised = socket.assigns.raised + 100
    HelloWeb.Endpoint.broadcast_from(self(), @topic, "donate_event", raised)
    {:noreply, assign(socket, :raised, raised)}
  end

  def handle_info(%{topic: @topic, payload: raised}, socket) do
    {:noreply, assign(socket, :raised, raised)}
  end
end
