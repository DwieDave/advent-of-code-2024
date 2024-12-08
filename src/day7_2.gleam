import day7_1.{CheckLineError, parse_line}
import gleam/dict
import gleam/result
import utils/common.{concat_ints, print_results}
import utils/files.{reduce_file_lines}

pub fn main() {
  #(solve("data/calibration7.txt"), solve("data/input7.txt")) |> print_results
}

pub fn solve(path: String) {
  let assert Ok(res) =
    reduce_file_lines(path, Ok(0), check_line, fn(acc, line_result) {
      use acc_val <- result.try(acc)
      use target <- result.try(line_result)
      Ok(acc_val + target)
    })
  res
}

fn check_line(line: String) {
  use #(target, numbers) <- result.try(parse_line(line))
  use first <- result.try(
    dict.get(numbers, 0) |> result.map_error(CheckLineError),
  )
  case try_combination_loop(numbers, target, first, 1) {
    True -> Ok(target)
    _ -> Ok(0)
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
          || try_combination_loop(
            numbers,
            target,
            concat_ints(acc, number),
            index + 1,
          )
        }
      }
  }
}
