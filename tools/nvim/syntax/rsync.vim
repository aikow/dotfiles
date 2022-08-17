if exists("b:current_syntax")
  finish
endif

syntax match rsyncAnchoredFile "\v\S@<!/.*$"
syntax match rsyncAnchoredDir "\v\S@<!/.*/$"

syntax match rsyncFile "\v[^/].*$"
syntax match rsyncDir "\v[^/].*/$"

syntax match rsyncExclude "\v^(\-|exclude)[ _]"
syntax match rsyncInclude "\v^(\+|include)[ _]"
syntax match rsyncMerge "\v^(\.|merge)[ _]"
syntax match rsyncDirMerge "\v^(\:|dir-merge)[ _]"
syntax match rsyncHide "\v^(H|hide)[ _]"
syntax match rsyncShow "\v^(S|show)[ _]"
syntax match rsyncProtect "\v^(P|protect)[ _]"
syntax match rsyncRisk "\v^(R|risk)[ _]"
syntax match rsyncClear "\v^(\!|clear)[ _]"

syntax match rsyncWildcard "\v\\@<!\*"
syntax match rsyncWildcard "\v\\@<!\?"
syntax region rsyncWildcardCharacterClass start=/\v\\@<!\[/ skip=/\v\\\]/ end=/\v\\@<!\]/

syntax keyword rsyncTodo TODO FIXME XXX BUG PERF contained
syntax match rsyncComment "\v#.*$" contains=@Spell,rsyncTodo

highlight def link rsyncComment Comment
highlight def link rsyncTodo Todo

highlight def link rsyncWildcard Operator
highlight def link rsyncWildcardCharacterClass Operator

highlight def link rsyncExclude RedBold
highlight def link rsyncInclude GreenBold
highlight def link rsyncMerge OrangeBold
highlight def link rsyncDirMerge Orange
highlight def link rsyncHide Grey
highlight def link rsyncShow Green
highlight def link rsyncProtect Red
highlight def link rsyncRisk YellowBold
highlight def link rsyncClear RedBold

highlight def link rsyncFile RsyncFile
highlight def link rsyncDir RsyncDir

highlight def link rsyncAnchoredFile RsyncAnchoredFile
highlight def link rsyncAnchoredDir RsyncAnchoredDir

let b:current_syntax = "rsync"
