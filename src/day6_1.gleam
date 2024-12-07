import gleam/set.{type Set}
import utils/common.{print_results}
import utils/files.{read_file_lines}
import utils/grid.{
  type Direction, type Grid, type Position, Direction, Position, Right,
  find_in_grid, grid_at, lines_to_grid, next_position, turn,
}

pub fn main() {
  #(solve("data/calibration6.txt"), solve("data/input6.txt")) |> print_results
}

pub fn solve(path: String) {
  let grid = read_file_lines(path) |> lines_to_grid
  let assert Ok(start_pos) = find_in_grid(grid, "^")
  walk(grid, set.new() |> set.insert(start_pos), start_pos, Direction(0, -1))
  |> set.size
}

fn walk(
  grid: Grid,
  visited: Set(Position),
  pos: Position,
  dir: Direction,
) -> Set(Position) {
  let next_pos = pos |> next_position(dir)
  let next_char = grid |> grid_at(next_pos)

  let new_visited = visited |> set.insert(pos)
  let next_walk = fn(pos, dir) { walk(grid, new_visited, pos, dir) }

  case next_char {
    Ok(".") -> next_walk(next_pos, dir)
    Ok("#") -> next_walk(pos, dir |> turn(Right))
    Ok("^") -> next_walk(next_pos, dir)
    Ok(_) -> new_visited
    Error(_) -> new_visited
  }
}
