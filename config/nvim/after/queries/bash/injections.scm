; extends

; TODO: Make this work for strings as well
; Inject -c style strings
(command
  name: (command_name
    (word)) @injection.language
  (#any-of? @injection.language "bash" "fish" "julia" "nu" "python")
  argument: ((word) @_c_arg
    (#eq? @_c_arg "-c")
    (raw_string) @injection.content)
  (#offset! @injection.content 0 1 0 -1))

; TODO: Make this work for strings as well
; AWK and GAWK scripts
(command
  name: (command_name
    (word)) @_cmd
  (#any-of? @_cmd "awk" "gawk")
  argument: (raw_string) @injection.content
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "awk"))
