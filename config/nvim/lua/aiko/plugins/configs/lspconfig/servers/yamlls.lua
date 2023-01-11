local S = {}

S.settings = {
  yaml = {
    schemaStore = {
      enable = true,
      url = "https://www.schemastore.org/api/json/catalog.json",
    },
    schemas = {
      kubernetes = "*{k8s,job}*.{yml,yaml}",
    },
    format = { enabled = false },
    validate = true,
    completion = true,
    hover = true,
  },
}

return S
