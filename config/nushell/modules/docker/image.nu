export def inspect [image: string] {
  let proc = (
    do {
      ^docker image inspect $image
    }
    | complete
  )

  if $proc.exit_code != 0 {
    error make {
      msg: $proc.stderr
      label: {
        text: "image defined here"
        span: (metadata $image).span
      }
    }
  }

  $proc.stdout
  | from json
  | transpose
  | transpose -dr
  | into filesize Size VirtualSize
}
