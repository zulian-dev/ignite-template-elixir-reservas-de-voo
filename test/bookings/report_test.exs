# Este teste é opcional, mas vale a pena tentar e se desafiar 😉

defmodule Flightex.Bookings.ReportTest do
  use ExUnit.Case, async: true

  alias Flightex.Bookings.Report
  import Flightex.Factory

  @filename "report-test.csv"

  describe "generate/1" do
    setup do
      Flightex.start_agents()

      :ok
    end

    test "when called, return the content" do
      params = %{
        complete_date: ~N[2001-05-07 12:00:00],
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: "12345678900",
        id: UUID.uuid4()
      }

      content = "12345678900,Brasilia,Bananeiras,2001-05-07 12:00:00"

      Flightex.create_or_update_booking(params)
      Report.generate(@filename)
      {:ok, file} = File.read(@filename)
      File.rm(@filename)

      assert file =~ content
    end
  end

  describe "generate_report/2" do
    setup do
      Flightex.start_agents()

      :booking
      |> build(
        complete_date: ~N[2001-10-08 15:30:00],
        local_origin: "La Paz, Bolivia",
        local_destination: "Charlotte, United States"
      )
      |> Flightex.create_or_update_booking()

      :booking
      |> build(
        complete_date: ~N[2003-12-01 12:20:00],
        local_origin: "San Francisco, United States",
        local_destination: "Ashgabat, Turkmenistan"
      )
      |> Flightex.create_or_update_booking()

      :booking
      |> build(
        complete_date: ~N[2004-04-12 05:24:00],
        local_origin: "Barcelona, Spain",
        local_destination: "Ottawa, Canada"
      )
      |> Flightex.create_or_update_booking()

      :booking
      |> build(
        complete_date: ~N[2015-04-29 10:24:00],
        local_origin: "Salt Lake City, United States",
        local_destination: "Boston, United States"
      )
      |> Flightex.create_or_update_booking()

      :ok
    end

    test "generate report whth dates interfal filter" do
      response =
        Report.generate_report(
          @filename,
          ~N[2001-01-01 00:00:00],
          ~N[2004-01-01 00:00:00]
        )

      expected_response = {:ok, "Report generated successfully"}

      File.rm(@filename)

      assert expected_response == response
    end

    test "when twoo dates has given, return the report with flighs btween dates" do
      Report.generate_report(@filename, ~N[2001-01-01 00:00:00], ~N[2004-01-01 00:00:00])

      {:ok, file} = File.read(@filename)
      File.rm(@filename)

      row1 = "12345678900,La Paz, Bolivia,Charlotte, United States,2001-10-08 15:30:00"
      row2 = "12345678900,San Francisco, United States,Ashgabat, Turkmenistan,2003-12-01 12:20:00"

      assert file =~ row1 and file =~ row2
    end
  end
end
