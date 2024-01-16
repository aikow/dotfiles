export def history [image: string] {
  let proc = (
    do {
      ^docker image history --no-trunc --format '{{json .}}' $image
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
  | lines
  | each { |it| $it | from json }
  | into datetime CreatedAt
  | into filesize Size

}

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
