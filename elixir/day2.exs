defmodule Day2 do
  def read_in() do
    with {:ok, body} <- File.read("../inputs/day2") do
      String.split(body, "\n")
      |> Enum.map(fn unformatted ->
        Regex.replace(~r/Game\s[\d]*:/, unformatted, "")
        |> (& Regex.replace(~r/\s/, &1, "")).()
        |> (& Regex.replace(~r/blue/, &1, " b")).()
        |> (& Regex.replace(~r/red/, &1, " r")).()
        |> (& Regex.replace(~r/green/, &1, " g")).()
        |> String.split(";")
      end)
    else
      {:error, reason} ->
        IO.inspect reason
        exit :shutdown
    end
  end
end

part1 = fn ->
  # Check the given rules each roll in a round
  check_cubes = fn counts ->
    #  Map containing game rules
    check = %{"r" => 12, "g" => 13, "b" => 14}
    # Split per game step
    String.split(counts, ",")
    |> Enum.all?(fn picked_cubes ->
      String.split(picked_cubes, " ")
      |> (fn cube ->
        # Validate individual cubes
        cube_count = hd(cube)
        cube_colour = cube |> Enum.reverse() |> hd()
        cube_count |> String.to_integer() <= Map.get(check, cube_colour)
      end).()
    end)
  end

  # Returns true if a round is valid given the rules and false otherwise
  process_round = fn round ->
    round
    |> Stream.map(& check_cubes.(&1))
    |> Enum.all?()
  end

  # Read input, split on line, format it
  Day2.read_in()
  |> Stream.with_index()
  |> Enum.reduce(0, fn {round, index}, count ->
    process_round.(round)
    |> if do
        count + index + 1
      else
        count
    end
  end)
  |> IO.inspect()
end
part2 = fn ->

  max_cubes = fn round ->
    base = %{"b" => 0, "r" => 0, "g" => 0}
    round
    |> Stream.map(fn step ->
      step
      |> String.split(",")
      |> Enum.reduce(base, fn cube, cube_max ->
          colour = Regex.run(~r/(b|r|g)/, cube) |> hd()
          tmp = Regex.run(~r/[\d]*/, cube) |> List.to_string() |> String.to_integer()
          Map.update!(cube_max, colour, fn curr -> max(tmp, curr)
        end)
      end)
    end)
  end

  combine_cube_maxes = fn round ->
    base = %{"b" => 0, "r" => 0, "g" => 0}

    round
    |> Enum.reduce(base, fn cube, cube_acc ->
      cube
      |> Enum.reduce(cube_acc, fn {colour, _}, tmp ->
          Map.update!(tmp, colour, & max(&1, Map.get(cube, colour)))
        end)
      end)
    end

  Day2.read_in()
  |> Enum.map(& max_cubes.(&1))
  |> Enum.map(& combine_cube_maxes.(&1))
  |> Enum.map(& Map.values(&1) |> Enum.product())
  |> Enum.sum()
  |> IO.inspect()
end

part1.()

part2.()
