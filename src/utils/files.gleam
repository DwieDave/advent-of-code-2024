import file_streams/file_stream.{type FileStream, open_read, read_line}
import gleam/function
import gleam/list
import gleam/string

type Reducer(state, value) =
  fn(state, value) -> state

type LineProcessor(value) =
  fn(String) -> value

// FILE UTILITIES
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
  read_line_loop("", stream, function.identity, string.append)
}

pub fn read_file_lines(path: String) -> List(String) {
  let assert Ok(stream) = open_read(path)
  read_line_loop([], stream, function.identity, fn(acc, line) {
    list.append(acc, [line |> string.trim_end])
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
