import gleam/dict.{type Dict}
import gleam/int.{to_string}
import gleam/io.{print}
import gleam/list
import gleam/result
import gleam/string
import utils/common.{to_dict}

pub type Grid =
  Dict(Int, Dict(Int, String))

pub type Position {
  Position(x: Int, y: Int)
}

pub type Direction {
  Direction(x: Int, y: Int)
}

// UTILITIES
pub fn print_results(results: #(Int, Int)) {
  let #(calibration, result) = results
  print("  calibration: " <> to_string(calibration) <> "\n")
  print("  main input : " <> to_string(result) <> "\n")
}

pub fn lines_to_grid(lines) -> Grid {
  lines
  |> list.map(fn(line) { line |> string.to_graphemes |> to_dict })
  |> to_dict
}

pub fn grid_at(grid: Grid, position: Position) {
  grid
  |> dict.get(position.y)
  |> result.try(dict.get(_, position.x))
}

pub fn next_position(position: Position, direction: Direction) {
  Position(position.x + direction.x, position.y + direction.y)
}
