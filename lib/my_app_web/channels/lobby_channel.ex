defmodule MyAppWeb.LobbyChannel do
  use MyAppWeb, :channel

  def join("lobby", payload, socket) do
    user_id =
      :crypto.strong_rand_bytes(10)
      |> Base.url_encode64

    send(self, :after_join)

    {:ok, assign(socket, :user_id, user_id)}
  end

  def handle_info(:after_join, socket) do
    broadcast socket, "updated", %{count: 0}
    {:noreply, socket}
  end

  def terminate(_reason, socket) do
    broadcast socket, "updated", %{count: 0}
    :ok
  end
end
