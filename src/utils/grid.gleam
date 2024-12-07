import gleam/dict.{type Dict}
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

pub fn lines_to_grid(lines) -> Grid {
  lines
  |> list.map(fn(line) { line |> string.to_graphemes |> to_dict })
  |> to_dict
}

pub type TurnDirection {
  Left
  Right
}

pub fn turn(direction: Direction, dir: TurnDirection) -> Direction {
  let Direction(x, y) = direction
  case dir {
    Right -> Direction(-y, x)
    Left -> Direction(y, -x)
  }
}

pub fn find_in_grid(grid: Grid, target: String) -> Result(Position, Nil) {
  grid
  |> dict.to_list()
  |> list.find_map(fn(row) {
    let #(y, row_dict) = row
    // Search in current row
    row_dict
    |> dict.to_list()
    |> list.find_map(fn(col) {
      let #(x, char) = col
      case char == target {
        True -> Ok(Position(x, y))
        False -> Error("Not found")
      }
    })
  })
}

pub fn grid_at(grid: Grid, position: Position) {
  grid
  |> dict.get(position.y)
  |> result.try(dict.get(_, position.x))
}

pub fn next_position(position: Position, direction: Direction) {
  Position(position.x + direction.x, position.y + direction.y)
}
