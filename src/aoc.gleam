import day1_1.{main as day1_1}
import gleam/int.{to_string}
import gleam/io.{print}
import gleam/list.{index_map, map}

type Puzzle {
  Puzzle(day: Int, functions: List(fn() -> Nil))
}

pub fn main() {
  [Puzzle(1, [day1_1])]
  |> execute_all_puzzles
}

fn execute_all_puzzles(puzzles: List(Puzzle)) {
  puzzles
  |> map(fn(puzzle) {
    puzzle.functions
    |> index_map(fn(puzzle_main, index) {
      print(
        "--------- DAY "
        <> to_string(puzzle.day)
        <> "_"
        <> to_string(index + 1)
        <> " ---------\n",
      )
      puzzle_main()
      print("-------------------------\n")
    })
  })
}
