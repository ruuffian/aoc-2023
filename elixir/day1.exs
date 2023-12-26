defmodule Day1 do
  # Find first and last integer and return the 2-digit number formed
  def find_cal_value line do
    #  Replace all letters with ""
    digits = Regex.replace(~r/[^0-9]/, line, "") |> String.graphemes()
    case digits do
      #  Default case
      [] ->
        0
      # Get first and last, combine and return
      _ ->
        first = digits |> List.first() |> String.to_integer()
        last = digits |> List.last() |> String.to_integer()
        first * 10 + last
    end
  end
end

part1 = fn ->
  # Read input, split on line and map to values -> reduce to sum
  with {:ok, body} <- File.read("../inputs/day1.txt") do
    String.split(body, "\n")
    |> Enum.map(& Day1.find_cal_value(&1))
    |> Enum.reduce(& &1 + &2)
  else
    {:error, reason} ->
      IO.puts reason
      exit :shutdown
  end
end

part2 = fn ->
  replace_numstrings = fn value ->
    regex = Regex.compile!("(one|two|three|four|five|six|seven|eight|nine)")
    mapping = %{"one" => "1", "two" => "2", "three" => "3", "four" => "4", "five" => "5", "six" => "6", "seven" => "7", "eight" => "8", "nine" => "9"}
    value
    |> String.graphemes()
    |> Enum.reduce("", fn char, acc ->
      chunk = acc <> char
      case Regex.run(regex, chunk) do
        nil ->
          chunk
        match ->
          num = hd(match)
          pre = num |> String.graphemes() |> hd()
          post = num |> String.graphemes() |> Enum.reverse() |> hd()
          Regex.replace(regex, chunk, pre <> Map.get(mapping, num) <> post)
      end
    end)
  end

  # Read input, split by line, replace text numbers -> reduce to sum
  with {:ok, body} <- File.read("../inputs/day1.txt") do
    String.split(body, "\n")
    |> Enum.map(& replace_numstrings.(&1))
    |> Enum.map(& Day1.find_cal_value(&1))
    |> Enum.reduce(& &1 + &2)
  else
    {:error, reason} ->
      IO.puts reason
      exit :shutdown
    end
end



IO.puts part1.()

IO.puts part2.()
