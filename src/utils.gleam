import file_streams/file_stream.{type FileStream, open_read, read_line}
import gleam/function.{identity}
import gleam/int.{to_string}
import gleam/io.{print}
import gleam/list.{append, drop, take}
import gleam/string.{trim_end}

type Reducer(state, value) =
  fn(state, value) -> state

type LineProcessor(value) =
  fn(String) -> value

pub fn reduce_file_lines(
  path: String,
  initial initial: state,
  process_with process: LineProcessor(value),
  reduce_with reduce: Reducer(state, value),
) -> state {
  let assert Ok(stream) = open_read(path)
  read_line_loop(initial, stream, process, reduce)
}

pub fn read_file(path: String) -> String {
  let assert Ok(stream) = open_read(path)
  read_line_loop("", stream, identity, string.append)
}

pub fn read_file_lines(path: String) -> List(String) {
  let assert Ok(stream) = open_read(path)
  read_line_loop([], stream, identity, fn(acc, line) {
    append(acc, [line |> trim_end])
  })
}

fn read_line_loop(
  initial: state,
  stream: FileStream,
  process: LineProcessor(value),
  reduce: Reducer(state, value),
) {
  case read_line(stream) {
    Error(_) -> initial
    Ok(line) ->
      line
      |> process
      |> reduce(initial, _)
      |> read_line_loop(stream, process, reduce)
  }
}

pub fn print_results(calibration: Int, result: Int) {
  print("Calibration Result: " <> to_string(calibration) <> "\n")
  print("Result: " <> to_string(result) <> "\n")
}

pub fn list_without(input: List(a), without: Int) {
  let before = take(input, without)
  let after = drop(input, without + 1)
  append(before, after)
}
