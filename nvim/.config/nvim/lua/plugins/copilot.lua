-- Lee el OAuth token de Copilot desde archivo protegido (chmod 600).
-- El language server actual ya no lee apps.json, pero soporta el token
-- via variable de entorno GITHUB_COPILOT_TOKEN.
local function read_copilot_token()
  local path = vim.fn.expand("~/.config/github-copilot/oauth_token")
  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok or not lines or not lines[1] then
    return nil
  end
  return vim.fn.trim(lines[1])
end

return {
  "zbirenbaum/copilot.lua",
  opts = {
    -- 1) nvm no expone node en shells no interactivos: apuntar directo al binario.
    -- 2) La red corporativa (SII) descarta el ClientHello TLS 1.3 de Node 24/25
    --    (key share post-cuántico ML-KEM) → los requests a GitHub mueren por
    --    timeout ("error RPC" en :Copilot auth). Se fuerza TLS 1.2 solo para
    --    el proceso del copilot-language-server.
    copilot_node_command = {
      vim.fn.expand("~/.nvm/versions/node/v25.1.0/bin/node"),
      "--tls-max-v1.2",
    },
    server_opts_overrides = {
      cmd_env = {
        GITHUB_COPILOT_TOKEN = read_copilot_token(),
      },
    },
  },
}
