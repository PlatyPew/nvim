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

- `gcc` or `clang`
- `git`
- `imagemagick`
- `node` (with `npm`)
- `python3` (with `pip` and `virtualenv`)
- `ripgrep`
- `tectonic`

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

| Model Name                     | Provider                  |
| ------------------------------ | ------------------------- |
| deepseek-r1-0528-qwen3-8b      | OpenRouter                |
| devstral-small                 | OpenRouter                |
| gemini-2.5-flash-preview-05-20 | Google AI                 |
| gpt-4.1                        | GitHub Marketplace Models |

#### macOS

```bash
# GitHub and Google API Keys
security add-generic-password -a "GitHub Token" -s "GITHUB_TOKEN" -w "<api_key>"
security add-generic-password -a "Gemini API Key" -s "GEMINI_API_KEY" -w "<api_key>"
security add-generic-password -a "OpenRouter API Key" -s "OPENROUTER_API_KEY" -w "<api_key>"
```

#### Linux

```bash
# GitHub and Google API Keys
mkdir -p ~/.apikeys
echo "<api_key>" > ~/.apikeys/GITHUB_TOKEN
echo "<api_key>" > ~/.apikeys/GEMINI_API_KEY
echo "<api_key>" > ~/.apikeys/OPENROUTER_API_KEY
chmod 600 ~/.apikeys/*
```
