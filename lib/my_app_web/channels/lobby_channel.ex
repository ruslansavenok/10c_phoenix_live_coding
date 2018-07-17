defmodule MyAppWeb.LobbyChannel do
  use MyAppWeb, :channel
  alias MyAppWeb.Presence

  def join("lobby", payload, socket) do
    user_id =
      :crypto.strong_rand_bytes(10)
      |> Base.url_encode64

    send(self, :after_join)

    {:ok, assign(socket, :user_id, user_id)}
  end

  def handle_info(:after_join, socket) do
    Presence.track(socket, socket.assigns.user_id, %{})

    broadcast socket, "updated", %{count: count_users(socket)}

    {:noreply, socket}
  end

  def terminate(_reason, socket) do
    Presence.untrack(socket, socket.assigns.user_id)

    broadcast socket, "updated", %{count: count_users(socket)}

    :ok
  end

  defp count_users(socket) do
    Presence.list(socket)
    |> Map.keys
    |> Enum.count
  end
end
