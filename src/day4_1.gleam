import gleam/dict.{type Dict}
import gleam/list
import gleam/result
import gleam/string
import utils.{print_results, read_file_lines, to_dict}

pub fn main() {
  #(solve("data/calibration4_1.txt"), solve("data/input4.txt")) |> print_results
}

pub type Grid =
  Dict(Int, Dict(Int, String))

pub type Position {
  Position(x: Int, y: Int)
}

pub type Direction {
  Direction(x: Int, y: Int)
}

pub type Game {
  Game(grid: Grid, letters: Dict(Int, String), check_length: Int)
}

const directions = [
  // vertical
  Direction(0, 1),
  Direction(0, -1),
  // horizontal
  Direction(1, 0),
  Direction(-1, 0),
  // diagonal
  Direction(1, 1),
  Direction(1, -1),
  Direction(-1, 1),
  Direction(-1, -1),
]

fn solve(path: String) {
  read_file_lines(path)
  |> lines_to_grid
  |> count_occurences("XMAS")
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

fn check_direction_loop(
  game: Game,
  position: Position,
  direction: Direction,
  char_index: Int,
) {
  let is_last = char_index == { game.check_length - 1 }
  let assert Ok(char_to_check) = game.letters |> dict.get(char_index)

  case grid_at(game.grid, position) {
    Error(_) -> False
    Ok(cur_char) ->
      case cur_char == char_to_check, is_last {
        True, True -> True
        False, _ -> False
        True, False ->
          check_direction_loop(
            game,
            position |> next_position(direction),
            direction,
            char_index + 1,
          )
      }
  }
}

pub fn next_position(position: Position, direction: Direction) {
  Position(position.x + direction.x, position.y + direction.y)
}

fn count_directions(game: Game, position: Position) {
  directions
  |> list.fold(0, fn(acc, direction) {
    let direction_result =
      game
      |> check_direction_loop(
        position |> next_position(direction),
        direction,
        1,
      )

    case direction_result {
      True -> acc + 1
      False -> acc
    }
  })
}

fn count_line_occurences(game: Game, y: Int, line: Dict(Int, String)) {
  let assert Ok(first) = dict.get(game.letters, 0)
  line
  |> dict.fold(0, fn(acc, x, char) {
    case char == first {
      False -> acc
      True -> acc + count_directions(game, Position(x, y))
    }
  })
}

fn count_occurences(grid: Grid, word: String) {
  let letters =
    word
    |> string.to_graphemes
    |> to_dict

  let game = Game(grid, letters, word |> string.length)

  game.grid
  |> dict.to_list
  |> list.fold(0, fn(acc, entries) {
    acc + count_line_occurences(game, entries.0, entries.1)
  })
}
