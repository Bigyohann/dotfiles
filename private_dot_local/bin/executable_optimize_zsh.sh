#!/bin/zsh

echo "🚀 Optimizing Zsh..."

echo "  [1/3] Compiling ~/.zshrc..."
zcompile ~/.zshrc

if [[ -f ~/.zsh_plugins.zsh ]]; then
    echo "  [2/3] Compiling Antidote static file..."
    zcompile ~/.zsh_plugins.zsh
fi

echo "  [3/3] Compiling local completion cache..."
zcompile ~/.zcompdump

source ~/.zshrc
echo "✨ Done! Zsh optimized and reloaded."
