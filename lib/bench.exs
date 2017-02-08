
defmodule Bench.ExSpirit.Parser do
  use ExSpirit.Parser, text: true

  # Throwing on error might indeed slow this down slightly, it is the proper
  # thing to do so it should be done.

  def parse_int_10(input) do
    %{error: nil} = parse(input, uint(10))
  end

  def parse_datetime(input) do
    %{error: nil} = parse(input, datetime())
  end

  defrule datetime(
    date() |> lit(?T) |> time()
  ), []

  defrule date(
    uint(10, 4, 4) # Year
    |> lit(?-)
    |> uint(10, 2, 2) # Month
    |> lit(?-)
    |> uint(10, 2, 2) # Day
  )

  defrule time(
    uint(10, 2, 2) # Hours
    |> lit(?:)
    |> uint(10, 2, 2) # Minutes
    |> lit(?:)
    |> uint(10, 2, 2) # Seconds
    |> lit(?.)
    |> uint(10, 4, 4) # Milliseconds
    |> alt([
      utc(),
      tz()
      ])
  )

  defrule utc(lit(?Z)), map: (fn _ -> "UTC" end).()

  defrule tz(seq([ alt([ char(?-), char(?+) ]), word()])), map: (&Enum.join/1).()

  defrule word(context) do # TODO:  Remove this once the `repeat` parser is made
    %{context |
      rest: "",
      result: context.rest,
    }
  end
end


defmodule Bench.Combine do
  use Combine

  def parse_int_10(input) do
    Combine.parse(input, integer())
  end

  def parse_datetime(input) do
    Combine.parse(input, datetime)
  end

  defp datetime, do: date() |> ignore(char("T")) |> time()

  defp date do
    label(integer(), "year")
    |> ignore(char("-"))
    |> label(integer(), "month")
    |> ignore(char("-"))
    |> label(integer(), "day")
  end

  defp time(previous) do
    previous
    |> label(integer(), "hour")
    |> ignore(char(":"))
    |> label(integer(), "minute")
    |> ignore(char(":"))
    |> label(float(), "seconds")
    |> either(
      map(char("Z"), fn _ -> "UTC" end),
      pipe([either(char("-"), char("+")), word()], &(Enum.join(&1)))
    )
  end
end

inputs = %{
  "parse_int_10" => {:parse_int_10, ["3462776573658"]},
  "parse_datetime" => {:parse_datetime, ["2014-07-22T12:30:05.0002Z"]}
}

Benchee.run(%{
  "ex_spirit" => fn {cmd, input} -> apply(Bench.ExSpirit.Parser, cmd, input) end,
  "combine"   => fn {cmd, input} -> apply(Bench.Combine, cmd, input) end
}, time: 3, inputs: inputs)
