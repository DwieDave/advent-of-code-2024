import gleam/int.{absolute_value}
import gleam/list.{fold, try_map}
import gleam/string.{split, trim_end}
import utils.{print_results, reduce_file_lines}

pub fn main() {
  let solve = reduce_file_lines(_, 0, parse_line, reduce_line_numbers)
  let calibration = solve("data/calibration2.txt")
  let result = solve("data/input2.txt")
  print_results(calibration, result)
}

pub type Level =
  List(Int)

pub fn parse_line(line: String) {
  let number_strs = split(line, " ")
  let assert Ok(nums) =
    try_map(number_strs, fn(num) { trim_end(num) |> int.parse })
  is_level_safe(nums)
}

pub fn is_level_safe(level: Level) {
  let assert [first, second, ..rest] = level
  #(
    {
      [second, ..rest]
      |> fold(#(True, first, int.compare(first, second)), fn(acc, num) {
        let #(result, last_num, last_direction) = acc
        let difference = absolute_value(num - acc.1)
        let new_direction = int.compare(last_num, num)
        #(
          result
            && { difference > 0 && difference <= 3 }
            && last_direction == new_direction,
          num,
          new_direction,
        )
      })
    }.0,
    level,
  )
}

fn reduce_line_numbers(acc: Int, level_info: #(Bool, Level)) {
  case level_info.0 {
    True -> acc + 1
    _ -> acc
  }
}
