; extends

;; SQL Queries
(assignment
  left: (identifier) @_id (#contains? @_id "query")
  right: (string) @injection.content
  (#set! injection.language "sql"))

;; SQL Queries
(assignment
  left: (identifier) @_id
  right: (string) @injection.content
  (#lua-match? @injection.content "^\"+%s*-- [Qq]uery")
  (#set! injection.language "sql"))

;; Regex
;; FIXME: This currently doesn't work for calls to the regex module - presumably
;; is this query not being used at all.
(call
  function: (attribute
    object: (identifier) @_mod
    (#any-of? @_mod "re" "regex")
    attribute: (identifier) @_fn
    (#any-of? @_fn "compile" "search" "match" "fullmatch" "sub"))
  arguments: (argument_list [
    (string)
    (concatenated_string)
  ] @injection.content)
  (#set! injection.language "regex"))
