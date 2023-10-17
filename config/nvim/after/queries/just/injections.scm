; extends

(setting lang: (NAME) @lang)

;; Inject bash as the default language into all recipe bodies.

;; Inject bash as the default language into all recipe bodies.
((item
  (setting lang: (NAME) @injection.language)
  (#any-of? @injection.language "awk" "bash" "nu" "python"))
 (_)*
 (item
   (recipe
     (body
       (recipe_body) @injection.content)))
 (#set! injection.include-children "true"))

((item
  (setting lang: (NAME) @language)
  (#not-any-of? @language "awk" "bash" "nu" "python"))
 (_)*
 (item
   (recipe
     (body
       (recipe_body) @injection.content)))
 (#set! injection.language "bash")
 (#set! injection.include-children "true"))

;; Inject the shebang interpreter as the language into the shebang body.
((shebang_recipe
  (shebang interpreter: (TEXT) @injection.language)
  (shebang_body) @injection.content)
  (#set! injection.include-children "true")) 
