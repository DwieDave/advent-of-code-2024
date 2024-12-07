import day4_1.{type Game, Game}
import gleam/bool
import gleam/dict.{type Dict}
import gleam/list
import gleam/string
import utils/aoc.{
  type Direction, type Grid, type Position, Direction, Position, grid_at,
  lines_to_grid, next_position, print_results,
}
import utils/common.{to_dict}
import utils/files.{read_file_lines}

pub fn main() {
  #(solve("data/calibration4_2.txt"), solve("data/input4.txt")) |> print_results
}

fn solve(path: String) {
  read_file_lines(path)
  |> lines_to_grid
  |> count_occurences("MAS")
}

const diagonals = [
  [Direction(1, -1), Direction(-1, 1)], [Direction(1, 1), Direction(-1, -1)],
]

fn check_x(game: Game, position: Position) {
  let assert #(Ok(first), Ok(last)) = #(
    game.letters |> dict.get(0),
    game.letters |> dict.get(2),
  )

  let at = fn(dir: Direction) {
    next_position(position, dir) |> grid_at(game.grid, _)
  }

  diagonals
  |> list.fold(True, fn(acc, diagonal) {
    let assert [f, l, ..] = diagonal
    case at(f), at(l) {
      Ok(first_diagonal), Ok(last_diagonal)
        if first_diagonal == first
        && last_diagonal == last
        || first_diagonal == last
        && last_diagonal == first
      -> True
      _, _ -> False
    }
    |> bool.and(acc)
  })
}

fn count_line_occurences_line(game: Game, y: Int, line: Dict(Int, String)) {
  let assert Ok(middle_char) = dict.get(game.letters, 1)
  line
  |> dict.fold(0, fn(acc, x, char) {
    case char == middle_char {
      False -> acc
      True -> acc + { check_x(game, Position(x, y)) |> bool.to_int }
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
    acc + count_line_occurences_line(game, entries.0, entries.1)
  })
}
