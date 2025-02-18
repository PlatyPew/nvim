<div align="center">
    <h1>光速 — Speed Of Light ⚡️</h1>
</div>

光速 (Speed Of Light) is a Neovim setup that has been carefully crafted to be feature-rich yet blazingly fast due to lazy loading as much as possible!

![JPG Compression Be Like](https://github.com/PlatyPew/neovim-init.lua/assets/23520617/93f99d8b-2e1f-4457-a182-51cddc47298d)

## 💻 Installation

To install, simply run the `./install.sh` script or run this command.

```bash
nvim --headless "+Lazy! sync" +qa
```

## 📁 File Structure

Plugins are stored and automatically sourced in `lua/plugins/`

```
~/.config/nvim
├── ftplugin
│  └── *.lua
├── init.lua
└── lua
   ├── core
   │  ├── autocmd.lua
   │  ├── functions.lua
   │  ├── mappings.lua
   │  └── options.lua
   └── plugins
      └── *.lua
```

## 🤖 AI Features

There are 2 AI features that are enabled by default:

1. Supermaven
2. Avante

### Supermaven

Supermaven should already be enabled by default, but to use the pro version, run `:SupermavenUsePro` and follow the instructions.

### Avante

Currently, Avante is configured to use the following models from the following providers:

| Model Name           | Provider                  |
| -------------------- | ------------------------- |
| codestral-latest     | Codestral Mistral AI      |
| gemini-exp-1206      | Google AI                 |
| gpt-4o               | GitHub Marketplace Models |
| gpt-4o-mini          | GitHub Marketplace Models |
| mistral-large-latest | Mistral AI                |

#### macOS

```bash
# GitHub and Google API Keys
security add-generic-password -a "GitHub Token" -s "GITHUB_TOKEN" -w "<api_key>"
security add-generic-password -a "Gemini API Key" -s "GEMINI_API_KEY" -w "<api_key>"
```

#### Linux

```bash
# GitHub and Google API Keys
mkdir -p ~/.apikeys
echo "<api_key>" > ~/.apikeys/github_token
echo "<api_key>" > ~/.apikeys/gemini_api_key
chmod 600 ~/.apikeys/*
```
