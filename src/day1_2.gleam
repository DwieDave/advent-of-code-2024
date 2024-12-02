import day1_1.{parse_line}
import gleam/dict.{get, upsert}
import gleam/list.{append, fold}
import gleam/option.{None, Some}
import utils.{print_results, reduce_file_lines}

pub fn main() {
  let calibration = solve("data/calibration1.txt")
  let result = solve("data/input1.txt")
  print_results(calibration, result)
}

fn solve(path: String) {
  let #(left_numbers, right_amounts) =
    reduce_file_lines(path, #([], dict.new()), parse_line, combine_line_numbers)

  left_numbers
  |> fold(0, fn(acc, left) {
    case right_amounts |> get(left) {
      Ok(value) -> acc + left * value
      _ -> acc
    }
  })
}

fn combine_line_numbers(
  acc: #(List(Int), dict.Dict(Int, Int)),
  line_num: #(Int, Int),
) {
  #(
    append(acc.0, [line_num.0]),
    upsert(acc.1, line_num.1, fn(old) {
      case old {
        Some(old_val) -> old_val + 1
        None -> 1
      }
    }),
  )
}
