defmodule Flightex.Bookings.Agent do
  alias Flightex.Bookings.Booking
  use Agent

  def start_link(%{}) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def save(%Booking{} = booking) do
    response = Agent.update(__MODULE__, &update_state(&1, booking))
    save_handler(response, booking)
  end

  def save(params), do: save_handler({:error, "invalid params"}, params)

  defp update_state(state, %Booking{id: id} = booking) do
    Map.put(state, id, booking)
  end

  defp save_handler(:ok, %Booking{id: id}), do: {:ok, id}
  defp save_handler(err, _), do: err

  def get(id) do
    Agent.get(__MODULE__, &get_booking(&1, id))
  end

  def list_all do
    Agent.get(__MODULE__, & &1)
  end

  defp get_booking(state, id) do
    case Map.get(state, id) do
      nil -> {:error, "Booking not found"}
      booking -> {:ok, booking}
    end
  end
end
