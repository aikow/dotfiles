local present, impatient = pcall(require, "impatient")

if present then
  impatient.enable_profile()
end

-- Setup packer and plugins
require("aiko.packer").bootstrap()
require("aiko.packer").setup()

require("aiko")
