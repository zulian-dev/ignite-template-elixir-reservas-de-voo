defmodule Flightex.Bookings.Report do
  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.Booking

  def generate(filename) do
    report = build_report()
    File.write!(filename, report)
  end

  defp build_report do
    BookingAgent.list_all()
    |> Enum.map(&build_report_row/1)
  end

  defp build_report_row(
         {_id,
          %Booking{
            user_id: user_id,
            local_origin: local_origin,
            local_destination: local_destination,
            complete_date: complete_date
          }}
       ) do
    "#{user_id},#{local_origin},#{local_destination},#{NaiveDateTime.to_string(complete_date)}"
  end
end
