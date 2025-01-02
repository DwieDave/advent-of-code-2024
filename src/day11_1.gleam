import gleam/int
import gleam/list
import gleam/otp/task
import gleam/string
import utils/common.{print_results}
import utils/files.{read_file}

pub fn main() {
  #(solve("data/calibration11.txt"), solve("data/input11.txt")) |> print_results
}

pub fn solve(path: String) {
  let input = read_file(path)
  let assert Ok(num_list) =
    input |> string.trim_end |> string.split(" ") |> list.try_map(int.parse)

  recursive_blink(num_list, 0) |> list.length
}

fn recursive_blink(input: List(Int), acc: Int) {
  case acc {
    i if i < 25 -> recursive_blink(blink(input), i + 1)
    _ -> input
  }
}

fn blink(input: List(Int)) {
  list.sized_chunk(input, 90)
  |> list.map(fn(chunk) {
    task.async(fn() {
      chunk
      |> list.fold([], fn(acc, num) {
        let digit_len =
          { num |> int.to_string |> string.length |> int.modulo(2) } == Ok(0)

        case num, digit_len {
          0, _ -> list.append(acc, [1])

          _, True -> {
            let assert Ok(half) =
              int.to_string(num) |> string.length |> int.divide(2)

            let assert Ok(split) =
              int.to_string(num)
              |> fn(str) {
                [string.drop_end(str, half), string.drop_start(str, half)]
              }
              |> list.try_map(int.parse)
            list.append(acc, split)
          }

          _, _ -> list.append(acc, [num * 2024])
        }
      })
    })
  })
  |> task.try_await_all(200)
  |> list.map(fn(result) {
    let assert Ok(num_list) = result
    num_list
  })
  |> list.flatten
}
