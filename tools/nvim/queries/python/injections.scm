(assignment
  left: (identifier) @_id (#contains? @_id "query")
  right: (string) @sql)

(assignment
  left: (identifier) @_id
  right: (string) @sql (#lua-match? @sql "^\"+%s*-- [Qq]uery"))
