if did_filetype()
  finish
endif

if getline(1) =~# '\v^#!.*/bin/(env\s+)?nu>'
  setfiletype nu
endif
