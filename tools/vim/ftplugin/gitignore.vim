if exists(b:did_ftplugin)
  return
endif

b:did_ft_plugin = 1

setlocal commentstring="# %s"

b:undo_ftplugin = nil
