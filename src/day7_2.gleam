import day7_1.{check_line}
import gleam/dict
import gleam/result
import utils/common.{concat_ints, print_results}
import utils/files.{reduce_file_lines}

pub fn main() {
  #(solve("data/calibration7.txt"), solve("data/input7.txt")) |> print_results
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
