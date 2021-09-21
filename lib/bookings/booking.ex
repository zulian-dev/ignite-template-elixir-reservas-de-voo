defmodule Flightex.Bookings.Booking do
  @keys [:complete_date, :local_origin, :local_destination, :user_id, :id]
  @enforce_keys @keys
  defstruct @keys

  def build(complete_date, local_origin, local_destination, user_id) when is_bitstring(user_id) do
    uuid = UUID.uuid4()

    booking = %__MODULE__{
      complete_date: complete_date,
      local_origin: local_origin,
      local_destination: local_destination,
      user_id: user_id,
      id: uuid
    }

    {:ok, booking}
  end

  def build(_complete_date, _local_origin, _local_destination, _user_id),
    do: {:error, "invalid params"}
end
