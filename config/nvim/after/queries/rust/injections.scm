; extends

;; SQL Queries
(call_expression
  function: (field_expression
    value: (identifier) @_obj (#any-of? @_obj "conn" "connection" "trans" "transaction")
    field: (field_identifier) @_fn (#vim-match? @_fn "^(execute|query|prepare)"))
  arguments: (arguments
    (raw_string_literal) @injection.content)
  (#offset! @injection.content 0 3 0 -2)
  (#set! injection.language "sql"))

;; Lua code in rlua's context.load
(call_expression
  function: (field_expression
    value: (identifier) @_obj (#any-of? @_obj "lua" "lua_ctx")
    field: (field_identifier) @_fn (#any-of? @_fn "load"))
  arguments: (arguments
    (raw_string_literal) @injection.content)
  (#offset! @injection.content 0 3 0 -2)
  (#set! injection.language "lua"))

; Regex
(call_expression
  function: (scoped_identifier
    path: (identifier) @_mod (#any-of? @_mod "Regex")
    name: (identifier) @_fn (#any-of? @_fn "new"))
  arguments: (arguments
    [(raw_string_literal) (string_literal)] @injection.content)
  (#set! injection.language "regex"))
