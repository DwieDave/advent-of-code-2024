import gleam/dict
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import utils/common.{print_results, to_dict}
import utils/files.{reduce_file_lines}

pub fn main() {
  #(solve("data/calibration7.txt"), solve("data/input7.txt")) |> print_results
}

pub type Error {
  ParseLineSplitError(Nil, String)
  ParseLineTargetError(Nil, String)
  ParseLineNumbersError(Nil, String)
  CheckLineError(Nil)
}

pub fn solve(path: String) {
  let assert Ok(res) =
    reduce_file_lines(
      path,
      Ok(0),
      check_line(with: try_combination_loop),
      fn(acc, line_result) {
        use acc_val <- result.try(acc)
        use target <- result.try(line_result)
        Ok(acc_val + target)
      },
    )
  res
}

pub fn check_line(with check: fn(dict.Dict(Int, Int), Int, Int, Int) -> Bool) {
  fn(line: String) {
    use #(target, numbers) <- result.try(parse_line(line))
    use first <- result.try(
      dict.get(numbers, 0) |> result.map_error(CheckLineError),
    )
    case check(numbers, target, first, 1) {
      True -> Ok(target)
      _ -> Ok(0)
    }
  }
}

fn try_combination_loop(
  numbers: dict.Dict(Int, Int),
  target: Int,
  acc: Int,
  index: Int,
) {
  let is_last = index == { numbers |> dict.size }
  case acc > target {
    True -> False
    False ->
      case acc == target, is_last {
        True, True -> True
        False, True -> False
        _, False -> {
          let assert Ok(number) = dict.get(numbers, index)
          try_combination_loop(numbers, target, acc + number, index + 1)
          || try_combination_loop(numbers, target, acc * number, index + 1)
        }
      }
  }
}

pub fn parse_line(line: String) {
  use #(target_str, number_str) <- result.try(
    line
    |> string.trim_end
    |> string.split_once(": ")
    |> result.map_error(ParseLineSplitError(_, line)),
  )

  use target <- result.try(
    target_str |> int.parse |> result.map_error(ParseLineTargetError(_, line)),
  )

  use numbers <- result.try(
    number_str
    |> string.split(" ")
    |> list.try_map(int.parse)
    |> result.map_error(ParseLineNumbersError(_, line)),
  )

  Ok(#(target, numbers |> to_dict))
}
