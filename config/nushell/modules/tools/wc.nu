export def main [file?: path] {
  let in_type = ($in | describe -d)

  let output = (
    if $file != null {
      open $file | lines
    } else if $in_type.type == string {
      $in
    }
    | do {
      ^wc
    }
    | complete
  )

  $output.stdout
  | parse -r '^\s*(?P<lines>\d+)\s+(?P<words>\d+)\s+(?P<chars>\d+)'
  | first
}
