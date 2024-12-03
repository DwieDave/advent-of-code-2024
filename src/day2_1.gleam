import gleam/int.{absolute_value}
import gleam/list.{fold, try_map}
import gleam/string.{split, trim_end}
import utils.{print_results, reduce_file_lines}

pub fn main() {
  let solve = reduce_file_lines(_, 0, parse_line, combine_line_numbers)
  #(solve("data/calibration2.txt"), solve("data/input2.txt")) |> print_results
}

pub type Level =
  List(Int)

pub fn parse_line(line: String) {
  let number_strs = split(line, " ")
  let parse = fn(num) { trim_end(num) |> int.parse }
  let assert Ok(level) = try_map(number_strs, parse)
  is_level_safe(level)
}

pub fn is_level_safe(level: Level) {
  let assert [first, second, ..rest] = level
  [second, ..rest]
  |> fold(#(True, first, int.compare(first, second)), fn(acc, num) {
    let #(result, last_num, last_order) = acc
    let difference = absolute_value(last_num - num)
    let new_order = int.compare(last_num, num)
    #(
      result && { difference > 0 && difference <= 3 } && last_order == new_order,
      num,
      new_order,
    )
  })
  |> fn(res) { #(res.0, level) }
}

fn combine_line_numbers(acc: Int, level_info: #(Bool, Level)) {
  case level_info.0 {
    True -> acc + 1
    _ -> acc
  }
}
