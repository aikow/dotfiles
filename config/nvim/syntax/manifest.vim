if exists("b:current_syntax")
  finish
endif

syntax match	manifestInclude	"\v^(recursive-)?include"

highlight def link manifestInclude Keyword

let b:current_syntax = 'manifest'
