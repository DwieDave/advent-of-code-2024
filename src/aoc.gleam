import day1_1.{main as day1_1}
import day1_2.{main as day1_2}
import day2_1.{main as day2_1}
import day2_2.{main as day2_2}
import day3_1.{main as day3_1}
import day3_2.{main as day3_2}
import day4_1.{main as day4_1}
import day4_2.{main as day4_2}
import day5_1.{main as day5_1}
import day5_2.{main as day5_2}
import gleam/int.{to_string}
import gleam/io.{print}
import gleam/list.{index_map, map}

type Puzzle {
  Puzzle(day: Int, functions: List(fn() -> Nil))
}

pub fn main() {
  print("\n")
  [
    Puzzle(day: 1, functions: [day1_1, day1_2]),
    Puzzle(day: 2, functions: [day2_1, day2_2]),
    Puzzle(day: 3, functions: [day3_1, day3_2]),
    Puzzle(day: 4, functions: [day4_1, day4_2]),
    Puzzle(day: 5, functions: [day5_1, day5_2]),
  ]
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
      print("---------------------------\n")
      print("\n")
    })
  })
}
