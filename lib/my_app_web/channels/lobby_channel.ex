defmodule MyAppWeb.LobbyChannel do
  use MyAppWeb, :channel

  def join("lobby", payload, socket) do
    {:ok, socket}
  end
end
