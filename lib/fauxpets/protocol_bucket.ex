defmodule Fauxpets.ProtocolBucket do
  use GenServer
  require Logger

  def login(bucket, user) do
    GenServer.cast(bucket, {:login, user})
  end

  def is_logged_in(bucket) do
    GenServer.call(bucket, {:is_logged_in})
  end

  def get_user(bucket) do
    GenServer.call(bucket, {:get_user})
  end

  @impl true
  def init(:ok) do
    {:ok, %{user: nil}}
  end

  @impl true
  def handle_call({:get_user}, _from, map) do
    {:reply, Map.get(map, :user), map}
  end

  @impl true
  def handle_call({:is_logged_in}, _from, map) do
    {:reply, Map.get(map, :user) != nil, map}
  end

  @impl true
  def handle_cast({:login, user}, map) do
    if Map.get(map, :user) do
      Logger.error("user tried to login twice!")
      {:noreply, map}
    else
      {:noreply, Map.put(map, :user, user)}
    end
  end
end
