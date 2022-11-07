; extends

;; SQL Queries
(call_expression
  function: (field_expression
    value: (identifier) @_obj (#any-of? @_obj "conn" "connection" "trans" "transaction")
    field: (field_identifier) @_fn (#contains? @_fn "execute"))
  arguments: (arguments
    (raw_string_literal) @sql))
