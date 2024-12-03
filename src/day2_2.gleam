import day2_1.{type Level, is_level_safe, parse_line}
import gleam/list.{length}
import utils.{drop_at, print_results, reduce_file_lines}

pub fn main() {
  let solve = reduce_file_lines(_, 0, parse_line, combine_line_numbers)
  #(solve("data/calibration2.txt"), solve("data/input2.txt")) |> print_results
}

fn retry_unsafe_level(level: Level, without_index: Int) -> Bool {
  let last_level = length(level) - 1
  let is_last = without_index >= last_level
  let #(is_safe, _) = level |> drop_at(without_index) |> is_level_safe

  case is_safe, is_last {
    True, _ -> True
    False, True -> False
    _, _ -> retry_unsafe_level(level, without_index + 1)
  }
}

fn combine_line_numbers(acc: Int, level_info: #(Bool, Level)) {
  case level_info {
    #(True, _) -> acc + 1
    #(False, level) ->
      case retry_unsafe_level(level, 0) {
        True -> acc + 1
        False -> acc
      }
  }
}
