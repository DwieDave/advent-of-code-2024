import gleam/bool
import gleam/dict
import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/regexp
import gleam/result
import gleam/set
import gleam/string
import utils/common.{pair_try_map, print_results, to_dict}
import utils/files.{read_file}

pub fn main() {
  #(solve("data/calibration5.txt"), solve("data/input5.txt")) |> print_results
}

pub type Rules =
  dict.Dict(Int, set.Set(Int))

fn solve(path: String) {
  let #(rules, updates) = read_file(path) |> parse

  updates
  |> list.fold(0, fn(acc, update) {
    case check_update(rules, update) {
      False -> acc
      True -> acc + get_middle_value(update)
    }
  })
}

pub fn get_middle_value(update: List(Int)) -> Int {
  let index = { list.length(update) - 1 } / 2
  let assert Ok(middle) = update |> to_dict |> dict.get(index)
  middle
}

pub fn check_update(rules: Rules, update: List(Int)) -> Bool {
  update
  |> list.index_fold(True, fn(update_acc, update_val, index) {
    case dict.get(rules, update_val) {
      Ok(rule_set) ->
        update_acc && check_rule(rule_set, update |> list.take(index))
      _ -> update_acc
    }
  })
}

fn check_rule(rule: set.Set(Int), slice: List(Int)) {
  slice
  |> list.fold(True, fn(acc, value) {
    acc && set.contains(rule, value) |> bool.negate
  })
}

pub fn parse(input: String) {
  let assert Ok(regex) = regexp.compile("^\\n", regexp.Options(False, True))
  let assert [rules_str, updates_str, ..] =
    input
    |> regexp.split(regex, _)
    |> list.map(fn(str) {
      string.split(str, "\n")
      |> list.filter(fn(line) { !{ string.trim(line) |> string.is_empty } })
    })

  let assert Ok(rule_pairs) =
    rules_str
    |> list.try_map(fn(str) {
      string.split_once(str, "|")
      |> result.try(pair_try_map(_, int.parse))
    })

  let rules =
    rule_pairs
    |> list.fold(dict.new(), fn(acc, rule) {
      let #(left_value, right_value) = rule
      dict.upsert(acc, left_value, fn(dict_value) {
        case dict_value {
          Some(current_set) -> current_set |> set.insert(right_value)
          None -> set.new() |> set.insert(right_value)
        }
      })
    })

  let assert Ok(updates) =
    updates_str
    |> list.try_map(fn(str) {
      string.split(str, ",") |> list.try_map(int.parse)
    })

  #(rules, updates)
}
