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

  def generate_report(filename, from_date, to_date) do
    report =
      BookingAgent.list_all()
      |> Enum.filter(&generate_report_filter_date(&1, from_date, to_date))
      |> Enum.map(&build_report_row/1)

    File.write!(filename, report)
    {:ok, "Report generated successfully"}
  end

  defp generate_report_filter_date(
         {_id, %Booking{complete_date: complete_date}},
         from_date,
         to_date
       ) do
    NaiveDateTime.compare(from_date, complete_date) == :lt and
      NaiveDateTime.compare(to_date, complete_date) == :gt
  end
end
