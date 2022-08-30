---@class Server
local Server = {}

function Server:on_init()
end

function Server:on_attach()
end

function Server:new(server)
  server = server or {}
  return setmetatable(server, {
    __index = self,
  })
end

return Server
