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

pub type NumberCount =
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

pub fn multi_blink(input: NumberCount, amount: Int) {
  list.range(1, amount)
  |> list.fold(input, fn(acc, _i) { blink(acc) })
  |> dict.values
  |> int.sum
}

fn blink(input: NumberCount) {
  let update_number_count = fn(acc, input) {
    let #(key, value) = input
    dict.upsert(acc, key, fn(current) {
      case current {
        Some(i) -> i + value
        None -> value
      }
    })
  }

  let split = fn(num_list) {
    let half = list.length(num_list) / 2
    let prefix = list.take(num_list, half)
    let suffix =
      list.drop(num_list, half)
      |> list.drop_while(fn(n) { n == "0" })
      |> fn(suffix) {
        case suffix {
          [] -> ["0"]
          _ -> suffix
        }
      }
    #(prefix, suffix)
  }

  input
  |> dict.fold(dict.new(), fn(acc, number_list, amount) {
    let digit_len_even = number_list |> list.length |> int.is_even

    case number_list, digit_len_even {
      ["0"], _ -> update_number_count(acc, #(["1"], amount))

      _, True -> {
        let #(prefix, suffix) = split(number_list)
        update_number_count(acc, #(prefix, amount))
        |> update_number_count(#(suffix, amount))
      }

      _, _ -> {
        let assert Ok(new_number_list) =
          number_list
          |> string.concat
          |> int.parse
          |> result.map(fn(i) { int.to_string(i * 2024) |> string.to_graphemes })
        update_number_count(acc, #(new_number_list, amount))
      }
    }
  })
}
