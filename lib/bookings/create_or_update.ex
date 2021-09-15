defmodule Flightex.Bookings.CreateOrUpdate do
  alias Flightex.Bookings.Booking
  alias Flightex.Bookings.Agent, as: BookingAgent

  def call(%{
        complete_date: complete_date,
        local_origin: local_origin,
        local_destination: local_destination,
        user_id: user_id
      }) do
    Booking.build(complete_date, local_origin, local_destination, user_id)
    |> save_booking()
  end

  def save_booking({:ok, %Booking{} = booking}) do
    BookingAgent.save(booking)
  end

  def save_booking({:error, _msg} = error) do
    error
  end
end
