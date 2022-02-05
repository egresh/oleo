local oleo = require('oleo')
local sumneko = require('oleo').sumneko

local workspace = sumneko.get_sumneko_workspace()


-- local data = { ["/Users/egresh/.local/share/neovimwip/nvim/site/pack/packer/start/nvim-web-devicons/lua"] = true }

-- for path, _ in pairs(data) do
--     print(path)
-- end

local rtp = sumneko.get_sumneko_rtp()

print(vim.inspect(workspace))
print('----')
print(vim.inspect(rtp))
