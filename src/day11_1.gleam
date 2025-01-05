import gleam/dict.{type Dict}
import gleam/function
import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/result
import gleam/string
import utils/common.{print_results}
import utils/files.{read_file}

pub fn main() {
  #(solve("data/calibration11.txt"), solve("data/input11.txt")) |> print_results
}

pub type Cache =
  Dict(List(String), Int)

pub fn solve(path: String) {
  parse(path)
  |> multi_blink(25)
}

pub fn parse(path: String) {
  read_file(path)
  |> string.trim_end
  |> string.split(" ")
  |> list.map(string.to_graphemes)
  |> list.group(function.identity)
  |> dict.map_values(fn(_, value) { list.length(value) })
}

pub fn multi_blink(input: Cache, amount: Int) {
  list.range(0, amount - 1)
  |> list.fold(input, fn(acc, _i) { blink(acc) })
  |> dict.values
  |> int.sum
}

pub fn blink(input: Cache) {
  let update_dict = fn(acc, input) {
    let #(key, value) = input
    dict.upsert(acc, key, fn(v) {
      case v {
        Some(i) -> i + value
        None -> value
      }
    })
  }

  let split = fn(num) {
    #(
      list.take(num, list.length(num) / 2),
      list.drop_while(list.drop(num, list.length(num) / 2), fn(n) { n == "0" }),
    )
  }

  input
  |> dict.fold(dict.new(), fn(acc, number_list, amount) {
    let digit_len_even = number_list |> list.length |> int.is_even

    case number_list, digit_len_even {
      ["0"], _ -> update_dict(acc, #(["1"], amount))

      _, True -> {
        let #(prefix, suffix) = split(number_list)
        let suffix = case suffix {
          [] -> ["0"]
          _ -> suffix
        }
        update_dict(acc, #(prefix, amount))
        |> update_dict(#(suffix, amount))
      }

      _, _ -> {
        let assert Ok(new_number_list) =
          number_list
          |> string.join("")
          |> int.parse
          |> result.map(fn(i) { int.to_string(i * 2024) |> string.to_graphemes })
        update_dict(acc, #(new_number_list, amount))
      }
    }
  })
}
