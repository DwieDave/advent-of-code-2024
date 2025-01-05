import day11_1
import utils/common.{print_results}

pub fn main() {
  #(solve("data/calibration11.txt"), solve("data/input11.txt")) |> print_results
}

pub fn solve(path: String) {
  day11_1.parse(path)
  |> day11_1.multi_blink(75)
}
