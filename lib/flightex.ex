defmodule Flightex do
  alias Flightex.Bookings
  alias Flightex.Users

  alias Bookings.CreateOrUpdate, as: CreateOrUpdateBooking

  defdelegate create_or_update_booking(params), to: CreateOrUpdateBooking, as: :call

  def start_agents do
    Bookings.Agent.start_link(%{})
    Users.Agent.start_link(%{})
  end
end
