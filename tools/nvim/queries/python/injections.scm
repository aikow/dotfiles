(assignment
  left: (identifier) @_id (#contains? @_id "query")
  right: (string) @sql (#offset! @sql 1 0 0 0))
