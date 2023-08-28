; extends

;; SQL Queries
(call_expression
  function: (field_expression
    value: (identifier) @_obj (#any-of? @_obj "conn" "connection" "trans" "transaction")
    field: (field_identifier) @_fn (#vim-match? @_fn "^(execute|query|prepare)"))
  arguments: (arguments
    (raw_string_literal) @injection.content)
  (#set! injection.language "sql"))

;; Regex
; (call_expression
;   function: (scoped_identifier
;     path: (identifier) @_mod (#any-of? @_mod "Regex")
;     name: (identifier) @_fn (#any-of? @_fn "new"))
;   arguments: (arguments
;     [(raw_string_literal) (concatenated_string)] @injection.content)
;   (#set! injection.language "regex"))
