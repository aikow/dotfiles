#!/usr/bin/env fish

argparse -N0 -X0 't/token=' -- $argv
or return

set -l token $_flag_token

cd lua

set -l plugin_source user/plugins/*.lua
set -l require_source (string replace -a / . (string split -r -m1 . $plugin_source)[1])

set -l plugins (lua -e "
-- Create empty vim namespace
vim = { api = {} }
local plugins = require('$require_source')

for k, _ in pairs(plugins) do
  print(k)
end
")

for plugin in $plugins
    set -l parts (string split / $plugin)
    set -l owner $parts[1]
    set -l repo $parts[2]

    set -l response (
    curl --silent \
      -H "Accept: application/vnd.github.v3+json" \
      -H "Authorization: token $token" \
      https://api.github.com/repos/$owner/$repo/license \
    | jq '.license.name'
  )
    echo "$plugin: $response"
end | column -t
