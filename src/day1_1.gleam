import gleam/int.{absolute_value}
import gleam/list.{append, fold, sort, zip}
import gleam/string.{split_once}
import utils.{print_results, reduce_file_lines}

pub fn main() {
  let calibration = solve("data/calibration1.txt")
  let result = solve("data/input1.txt")
  print_results(calibration, result)
}

fn solve(path: String) {
  let #(left_numbers, right_numbers) =
    reduce_file_lines(path, #([], []), parse_line, combine_line_numbers)

  let #(left_sorted, right_sorted) = #(
    sort(left_numbers, int.compare),
    sort(right_numbers, int.compare),
  )

  zip(left_sorted, right_sorted)
  |> fold(0, fn(acc, val) { acc + absolute_value(val.0 - val.1) })
}

pub fn parse_line(line: String) {
  let assert Ok(#(left_str, right_str)) = split_once(line, "   ")

  let assert #(Ok(left), Ok(right)) = #(
    left_str |> int.parse,
    right_str |> string.trim_end |> int.parse,
  )
  #(left, right)
}

fn combine_line_numbers(acc: #(List(Int), List(Int)), line_num: #(Int, Int)) {
  let #(left_numbers, right_numbers) = acc
  #(append(left_numbers, [line_num.0]), append(right_numbers, [line_num.1]))
}
