<div align="center">
    <h1>光速 — Speed Of Light ⚡️</h1>
</div>

光速 (Speed Of Light) is a Neovim setup that has been carefully crafted to be feature-rich yet blazingly fast due to lazy loading as much as possible!

![JPG Compression Be Like](https://github.com/user-attachments/assets/03f5d637-9078-4ca5-9235-545ea5e0d141)

## 💻 Installation

To install, simply run the `./install.sh` script or run this command.

```bash
nvim --headless "+Lazy! sync" +qa
```

### 📦 Dependencies

- `fd`
- `gcc` or `clang`
- `git`
- `imagemagick`
- `node` (with `npm`)
- `pngpaste` or `xclip`
- `python3` (with `pip` and `virtualenv`)
- `ripgrep`
- `tectonic`

## 📁 File Structure

Plugins are stored and automatically sourced in `lua/plugins/`

```
~/.config/nvim
├── ftplugin
│   └── *.lua
├── init.lua
├── lazy-lock.json
├── lua
│   ├── core
│   │   ├── autocmd.lua
│   │   ├── functions.lua
│   │   ├── mappings.lua
│   │   └── options.lua
│   ├── neovide
│   │   └── init.lua
│   ├── plugins
│   │   └── *.lua
│   └── versions.lua
└── README.md
```

## 🤖 AI Features

There are 3 AI features that are enabled by default:

1. Supermaven
2. Avante
3. McpHub

### Supermaven

Supermaven should already be enabled by default, but to use the pro version, run `:SupermavenUsePro` and follow the instructions.

### Avante

Currently, Avante is configured to use the following models from the following providers:

| Model Name           | Provider                  |
| -------------------- | ------------------------- |
| gemini-2.5-flash     | Google AI                 |
| mistral-large-latest | Mistral AI                |
| deepseek-r1          | OpenRouter                |
| gpt-4.1              | GitHub Marketplace Models |

#### macOS

How to store API Keys

```bash
security add-generic-password -a "Gemini API Key" -s "GEMINI_API_KEY" -w "<api_key>"
security add-generic-password -a "Mistral API Key" -s "MISTRAL_API_KEY" -w "<api_key>"
security add-generic-password -a "OpenRouter API Key" -s "OPENROUTER_API_KEY" -w "<api_key>"
security add-generic-password -a "GitHub Token" -s "GITHUB_TOKEN" -w "<api_key>"
```

#### Linux

How to store API Keys

```bash
# GitHub and Google API Keys
printf "<api_key>" | secret-tool store --label="Gemini API Key" token GEMINI_API_KEY
printf "<api_key>" | secret-tool store --label="Mistral API Key" token MISTRAL_API_KEY
printf "<api_key>" | secret-tool store --label="OpenRouter API Key" token OPENROUTER_API_KEY
printf "<api_key>" | secret-tool store --label="GitHub Token" token GITHUB_TOKEN
```

### McpHub

Currently, McpHub is configured to use the following servers from the following authors:

| MCP Server          | Author/Provider      |
| ------------------- | -------------------- |
| Playwright          | executeautomation    |
| Sequential Thinking | modelcontextprotocol |
| Context7            | upstash              |
| Neovim              | Native               |
| Docker MCP Toolkit  | Docker               |

#### Configuration

```json
{
  "nativeMCPServers": {
    "mcphub": {
      "autoApprove": ["get_current_servers", "toggle_mcp_server"]
    },
    "neovim": {
      "autoApprove": []
    }
  },
  "mcpServers": {
    "github.com/upstash/context7-mcp": {
      "args": ["-y", "@upstash/context7-mcp"],
      "disabled": false,
      "command": "npx",
      "autoApprove": ["resolve-library-id", "get-library-docs"]
    },
    "github.com/modelcontextprotocol/servers/tree/main/src/sequentialthinking": {
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"],
      "command": "npx",
      "custom_instructions": {
        "text": "Input parameters should use camelCase, not snake_case. For example, thoughts_needed should be changed to thoughtsNeeded."
      },
      "disabled": false,
      "autoApprove": ["sequentialthinking"]
    },
    "docker-desktop-mcp-toolkit": {
      "args": ["mcp", "gateway", "run"],
      "disabled": true,
      "command": "docker",
      "autoApprove": []
    },
    "github.com/executeautomation/mcp-playwright": {
      "args": ["-y", "@executeautomation/playwright-mcp-server"],
      "command": "npx",
      "disabled": false
    }
  }
}
```
