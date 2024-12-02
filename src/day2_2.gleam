import day2_1.{type Level, is_level_safe, parse_line}
import gleam/list.{length}
import utils.{list_without, print_results, reduce_file_lines}

pub fn main() {
  let solve = reduce_file_lines(_, 0, parse_line, reduce_line_numbers)
  let calibration = solve("data/calibration2.txt")
  let result = solve("data/input2.txt")
  print_results(calibration, result)
}

fn retry_unsafe_level(level: Level, without: Int) -> Bool {
  let last_level = length(level) - 1
  let is_last = without >= last_level
  let #(is_safe, _) = level |> list_without(without) |> is_level_safe

  case is_safe, is_last {
    True, _ -> True
    False, True -> False
    _, _ -> retry_unsafe_level(level, without + 1)
  }
}

fn reduce_line_numbers(acc: Int, safe: #(Bool, Level)) {
  case safe {
    #(True, _) -> acc + 1
    #(False, level) ->
      case retry_unsafe_level(level, 0) {
        True -> acc + 1
        False -> acc
      }
  }
}
