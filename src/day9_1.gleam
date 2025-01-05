import gleam/int
import gleam/list
import gleam/pair
import gleam/result
import gleam/string
import utils/common.{print_results}
import utils/files.{read_file}

pub fn main() {
  #(solve("data/calibration9.txt"), solve("data/input9.txt")) |> print_results
}

type Block {
  Empty
  File(Int)
}

pub fn solve(path: String) {
  let memory = read_file(path)
  let assert Ok(blocks) = to_blocks(memory)

  compress_blocks(blocks)
  |> list.filter(non_empty_blocks)
  |> list.index_fold(0, fn(acc, block, position) {
    case block {
      Empty -> acc
      File(file_id) -> {
        acc + position * file_id
      }
    }
  })
}

fn to_blocks(input: String) {
  input
  |> string.trim_end
  |> string.to_graphemes
  |> list.try_map(int.parse)
  |> result.map(
    list.fold(_, #([], True, 0), fn(acc, block_nr) {
      let #(checksum, is_file, file_id) = acc
      case is_file {
        True -> #(
          list.append(checksum, list.repeat(File(file_id), block_nr)),
          False,
          file_id + 1,
        )
        False -> #(
          list.append(checksum, list.repeat(Empty, block_nr)),
          True,
          file_id,
        )
      }
    }),
  )
  |> result.map(fn(triple) { triple.0 })
}

fn non_empty_blocks(block) {
  case block {
    Empty -> False
    _ -> True
  }
}

fn compress_blocks(blocks: List(Block)) {
  let reversed_file_blocks =
    blocks
    |> list.filter(non_empty_blocks)
    |> list.reverse

  let used_space =
    blocks
    |> list.fold(0, fn(acc, block) {
      case block {
        Empty -> acc
        _ -> acc + 1
      }
    })

  blocks
  |> list.index_fold(#([], reversed_file_blocks), fn(acc, block, index) {
    let #(compressed, reversed_blocks) = acc
    case block {
      Empty if index < used_space -> {
        let assert Ok(next_file_block) = reversed_blocks |> list.first
        #(
          list.append(compressed, [next_file_block]),
          reversed_blocks |> list.drop(1),
        )
      }
      _ if index < used_space -> #(
        list.append(compressed, [block]),
        reversed_blocks,
      )
      _ -> #(list.append(compressed, [Empty]), [])
    }
  })
  |> pair.first
}
