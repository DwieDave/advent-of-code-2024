import gleam/int
import gleam/list.{fold, map}
import gleam/option.{type Option}
import gleam/regexp.{scan}
import gleam/result
import utils.{print_results, read_file}

pub fn main() {
  let solve = fn(path: String) { read_file(path) |> parse_memory }
  #(solve("data/calibration3.txt"), solve("data/input3.txt")) |> print_results
}

pub fn calculate_submatches(submatches: List(Option(String))) {
  let numbers =
    submatches
    |> option.values
    |> map(int.parse)
    |> result.values
  let assert [first, second, ..] = numbers
  first * second
}

fn parse_memory(line: String) {
  let assert Ok(regex) = regexp.from_string("mul\\((\\d+)\\,(\\d+)\\)")
  scan(regex, line)
  |> fold(0, fn(acc, match) { acc + calculate_submatches(match.submatches) })
}
