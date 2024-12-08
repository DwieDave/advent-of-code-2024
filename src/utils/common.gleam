import gleam/dict
import gleam/int.{to_string}
import gleam/io.{print}
import gleam/list.{append, drop, take}
import gleam/result
import gleam/string

pub fn print_results(results: #(Int, Int)) {
  let #(calibration, result) = results
  print("  calibration: " <> to_string(calibration) <> "\n")
  print("  main input : " <> to_string(result) <> "\n")
}

pub fn to_dict(list: List(a)) {
  list |> list.index_map(fn(el, i) { #(i, el) }) |> dict.from_list
}

pub fn pair_map(pair: #(a, a), fun: fn(a) -> b) -> #(b, b) {
  #(fun(pair.0), fun(pair.1))
}

pub fn pair_try_map(
  pair: #(a, a),
  fun: fn(a) -> Result(b, Nil),
) -> Result(#(b, b), Nil) {
  use a_res <- result.try(fun(pair.0))
  use b_res <- result.try(fun(pair.1))
  Ok(#(a_res, b_res))
}

pub fn drop_at(input: List(a), without: Int) {
  let before = take(input, without)
  let after = drop(input, without + 1)
  append(before, after)
}

pub fn concat_ints(left: Int, right: Int) -> Int {
  let left_str = int.to_string(left)
  let right_str = int.to_string(right)
  let assert Ok(res) =
    string.concat([left_str, right_str])
    |> int.parse
  res
}
