local function map_visits(lhs, rhs, desc)
  vim.keymap.set(
    "n",
    "<leader>j" .. lhs,
    type(rhs) == "string" and "<cmd>" .. rhs .. "<cr>" or rhs,
    { desc = "mini.visits" .. desc }
  )
end

local function make_select_path(select_global, recency_weight)
  local visits = require("mini.visits")
  local sort = visits.gen_sort.default({ recency_weight = recency_weight })
  local select_opts = { sort = sort }
  return function()
    local cwd = select_global and "" or vim.uv.cwd()
    visits.select_path(cwd, select_opts)
  end
end

local function map_select(lhs, desc, ...) map_visits(lhs, make_select_path(...), desc) end

local minivisits = require("mini.visits")
minivisits.setup({})

map_select("r", "select recent (cwd)", false, 1)
map_select("R", "select recent (all)", true, 1)
map_select("y", "select frecent (cwd)", false, 0.5)
map_select("Y", "select frecent (all)", true, 0.5)
map_select("f", "select frequent (cwd)", false, 0)
map_select("F", "select frequent (all)", true, 0)

map_visits("j", "lua MiniVisits.add_label()", "add label")
map_visits("J", "lua MiniVisits.remove_label()", "remove label")
map_visits("l", "lua MiniVisits.select_label()", "select label (cwd)")
map_visits("L", 'lua MiniVisits.select_label("", "")', "select label (all)")
