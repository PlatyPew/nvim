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
2. Sidekick

### macOS

How to store API Keys

```bash
security add-generic-password -a "Gemini API Key" -s "GEMINI_API_KEY" -w "<api_key>"
security add-generic-password -a "Mistral API Key" -s "MISTRAL_API_KEY" -w "<api_key>"
security add-generic-password -a "OpenRouter API Key" -s "OPENROUTER_API_KEY" -w "<api_key>"
security add-generic-password -a "Groq Token" -s "GROQ_API_KEY" -w "<api_key>"
```

### Linux

How to store API Keys

```bash
printf "<api_key>" | secret-tool store --label="Gemini API Key" token GEMINI_API_KEY
printf "<api_key>" | secret-tool store --label="Mistral API Key" token MISTRAL_API_KEY
printf "<api_key>" | secret-tool store --label="OpenRouter API Key" token OPENROUTER_API_KEY
printf "<api_key>" | secret-tool store --label="Groq API Key" token GROQ_API_KEY
```
