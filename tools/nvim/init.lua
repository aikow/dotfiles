local present, impatient = pcall(require, "impatient")

if present then
  impatient.enable_profile()
end

require("aiko")

-- Setup packer and plugins
require("aiko.packer").bootstrap()
require("aiko.packer").run()
require("aiko.plugins")
