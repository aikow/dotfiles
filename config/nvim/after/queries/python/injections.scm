; extends

;; SQL Queries
(assignment
  left: (identifier) @_id (#contains? @_id "query")
  right: (string) @sql)

(assignment
  left: (identifier) @_id
  right: (string) @sql (#lua-match? @sql "^\"+%s*-- [Qq]uery"))

;; Regex
(call
  function: (attribute
    object: (identifier) @_mod (#any-of? @_mod "re" "regex")
    attribute: (identifier) @_fn (#any-of? @_fn "compile" "search" "match" "fullmatch" "sub"))
  arguments: (argument_list
    [(string) (concatenated_string)] @regex))
