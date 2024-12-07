import day2_1.{type Level, is_level_safe, parse_line}
import gleam/list.{length}
import gleam/pair
import utils/aoc.{print_results}
import utils/common.{drop_at}
import utils/files.{reduce_file_lines}

pub fn main() {
  #(solve("data/calibration2.txt"), solve("data/input2.txt")) |> print_results
}

pub fn solve(path: String) {
  reduce_file_lines(path, 0, parse_line, combine_line_numbers)
}

fn retry_unsafe_level(level: Level, without_index: Int) -> Bool {
  let is_last = without_index >= length(level) - 1
  let is_safe = level |> drop_at(without_index) |> is_level_safe |> pair.first

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
