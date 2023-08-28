; extends

;; Regex
(block_mapping_pair
  key: (_) @_key (#any-of? @_key "re" "regex" "pattern")
  value: (flow_node [
    (single_quote_scalar)
    (double_quote_scalar)
  ] @injection.content)
  (#set! injection.language "regex"))
