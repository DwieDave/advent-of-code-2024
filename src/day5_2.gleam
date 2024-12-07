import day5_1.{type Rules, check_update, get_middle_value, parse}
import gleam/dict
import gleam/int
import gleam/list
import gleam/order
import gleam/result
import gleam/set.{contains}
import utils/aoc.{print_results}
import utils/files.{read_file}

pub fn main() {
  #(solve("data/calibration5.txt"), solve("data/input5.txt")) |> print_results
}

fn solve(path: String) {
  let #(rules, updates) = read_file(path) |> parse

  updates
  |> list.filter(fn(update) { !check_update(rules, update) })
  |> list.map(fn(update) { sort_update(rules, update) |> get_middle_value })
  |> list.fold(0, int.add)
}

pub fn sort_update(rules: Rules, update: List(Int)) -> List(Int) {
  update
  |> list.sort(fn(a, b) {
    let a_rules = dict.get(rules, a) |> result.unwrap(set.new())
    let b_rules = dict.get(rules, b) |> result.unwrap(set.new())

    case a_rules |> contains(b), b_rules |> contains(a) {
      // a must come after b
      True, False -> order.Gt
      // a must come before b
      False, True -> order.Lt
      // no direct relationship
      _, _ -> order.Eq
    }
  })
}
