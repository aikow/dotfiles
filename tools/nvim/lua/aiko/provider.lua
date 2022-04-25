local function python()
  -- Set the python provider for neovim
  local pynvim_path = vim.fn.expand("$HOME/.miniconda3/envs/pynvim3/bin/python")
  if vim.fn.filereadable(pynvim_path) ~= 1 then
    -- Bootstrap the python3 conda env with pynvim
    print("Bootstrapping the conda python3 env...")
    vim.fn.execute("!" .. vim.fn.expand("conda env create -f $HOME/.dotfiles/tools/vim/envs/pynvim3.yml"))
  end
  vim.g.python3_host_prog = pynvim_path
end

return {
  setup_python = python,
}
