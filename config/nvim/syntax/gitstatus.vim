if exists("b:current_syntax")
  finish
endif

syntax match gitstatusBranch "^On branch \zs.*$"
syntax match gitstatusTracking "^Your branch is up to date with '\zs.*\ze'\.$"

syntax match gitstatusHint "([^)]*)"

syntax region gitstatusStaged start="^Changes to be committed:$" end="^$" contains=gitstatusHint
syntax match gitstatusStagedNew "^\tnew file:\s*\zs.*$" contained containedin=gitstatusStaged
syntax match gitstatusStagedModified "^\tmodified:\s*\zs.*$" contained containedin=gitstatusStaged
syntax match gitstatusStagedDeleted "^\tdeleted:\s\zs.*$" contained containedin=gitstatusStaged
syntax match gitstatusStagedHeader "^Changes to be committed:$" contained containedin=gitstatusStaged

syntax region gitstatusTracked start="^Changes not staged for commit:$" end="^$" contains=gitstatusHint
syntax match gitstatusTrackedMoved "^\tmoved:\s*\zs.*$" contained containedin=gitstatusTracked
syntax match gitstatusTrackedModified "^\tmodified:\s*\zs.*$" contained containedin=gitstatusTracked
syntax match gitstatusTrackedDeleted "^\tdeleted:\s*\zs.*$" contained containedin=gitstatusTracked
syntax match gitstatusTrackedHeader "^Changes not staged for commit:$" contained containedin=gitstatusTracked

syntax region gitstatusUntracked start="^Untracked files:$" end="^$" contains=gitstatusHint
syntax match gitstatusUntrackedDir "^\t\zs.*/$" contained containedin=gitstatusUntracked
syntax match gitstatusUntrackedFile "^\t\zs.*[^/]$" contained containedin=gitstatusUntracked
syntax match gitstatusUntrackedHeader "^Untracked files:$" contained containedin=gitstatusUntracked


highlight def link gitstatusHint Comment

highlight def link gitstatusBranch Constant
highlight def link gitstatusTracking Constant

highlight def link gitstatusStagedHeader @markup.heading
highlight def link gitstatusStagedNew Added
highlight def link gitstatusStagedModified Changed
highlight def link gitstatusStagedDeleted Removed

highlight def link gitstatusTrackedHeader @markup.heading
highlight def link gitstatusTrackedMoved Changed
highlight def link gitstatusTrackedModified Changed
highlight def link gitstatusTrackedDeleted Removed

highlight def link gitstatusUntrackedHeader @markup.heading
highlight def link gitstatusUntrackedFile Added
highlight def link gitstatusUntrackedDir Include

let b:current_syntax = 'gitstatus'
