defmodule Fauxpets.ProtocolBucket do
  use GenServer
  require Logger

  # Client

  def login(bucket, user) do
    GenServer.cast(bucket, {:login, user})
  end

  def is_logged_in(bucket) do
    GenServer.call(bucket, {:is_logged_in})
  end

  def get_user(bucket) do
    GenServer.call(bucket, {:get_user})
  end

  def get_all_inventories(bucket) do
    GenServer.call(bucket, {:get_all_inventories})
  end

  def get_inventory(bucket, inv_no) do
    GenServer.call(bucket, {:get_inventory, inv_no})
  end

  def is_slot_occupied(bucket, inv_no, slot_index) do
    GenServer.call(bucket, {:is_slot_occupied, inv_no, slot_index})
  end

  # Server

  @impl true
  def init(:ok) do
    {:ok, %{user: nil, inventory: []}}
  end

  @impl true
  def handle_call({:get_user}, _from, map) do
    {:reply, Map.get(map, :user), map}
  end

  @impl true
  def handle_call({:is_logged_in}, _from, map) do
    {:reply, Map.get(map, :user) != nil, map}
  end

  def handle_call({:get_all_inventories}, _from, map) do
    {:reply, Map.get(map, :inventories), map}
  end

  def handle_call({:get_inventory, inv_no}, _from, map) do
    {:reply, Enum.at(Map.get(map, :inventories), inv_no), map}
  end

  def handle_call({:is_slot_occupied, inv_no, slot_index}, _from, map) do
    box = Enum.at(Map.get(map, :inventories), inv_no)

    if box == nil do
      raise "bad box #{inv_no}"
    end

    cond do
      Enum.any?(box.inventory.stacks, fn stack -> stack.slot_index == slot_index end) ->
        {:reply, {:occupied, :inventory}}
      Enum.any?(box.giftbox.gifts, fn gift -> gift.slot_index == slot_index end) ->
        {:reply, {:occupied, :giftbox}}
      true ->
        {:reply, {:unoccupied}}
    end
  end

  @impl true
  def handle_cast({:login, user}, map) do
    if Map.get(map, :user) do
      Logger.error("user tried to login twice!")
      {:noreply, map}
    else

      {:noreply, Map.put(Map.put(map, :user, user), :inventories, user.boxes)}
    end
  end
end
