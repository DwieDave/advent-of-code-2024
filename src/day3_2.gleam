import day3_1.{calculate_submatches}
import gleam/list
import gleam/pair
import gleam/regexp
import utils.{print_results, read_file}

pub fn main() {
  let solve = fn(path: String) { read_file(path) |> parse_memory }
  #(solve("data/calibration3_2.txt"), solve("data/input3.txt")) |> print_results
}

fn parse_memory(memory: String) {
  let assert Ok(regex) =
    regexp.from_string("mul\\((\\d+)\\,(\\d+)\\)|don\\'t\\(\\)|do\\(\\)")

  regexp.scan(regex, memory)
  |> list.fold(#(0, True), fn(acc, match) {
    let #(sum, is_active) = acc
    case match.content, is_active {
      "don't()", _ -> #(sum, False)
      "do()", _ -> #(sum, True)
      _, True -> #(sum + calculate_submatches(match.submatches), is_active)
      _, _ -> acc
    }
  })
  |> pair.first
}
