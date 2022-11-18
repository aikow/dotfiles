; extends

;; SQL Queries
(call_expression
  function: (field_expression
    value: (identifier) @_obj (#any-of? @_obj "conn" "connection" "trans" "transaction")
    field: (field_identifier) @_fn (#vim-match? @_fn "^(execute|query|prepare)"))
  arguments: (arguments
    (raw_string_literal) @sql))
