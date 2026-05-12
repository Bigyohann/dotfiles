# ✨ Biggy's Dotfiles 🚀

A modular, private, and highly automated dotfiles configuration managed by [chezmoi](https://www.chezmoi.io/).

## 🌟 Key Features

-   **Privacy First**: Personal emails and company names are hidden using chezmoi templates and local variables.
-   **Dynamic Identities**: Automatically switches Git identities (Email + SSH Keys) based on the directory you are working in.
-   **Pro Aliases**: Custom aliases for JSON formatting (`json`), Docker Compose (`dcpl`), advanced Git logging (`gl`), and Zsh optimization (`zopt`).
-   **Automated SSH**: Self-generating SSH keys for personal and professional identities during provisioning.
-   **Zsh Performance**: Pre-compiled shell configuration and lazy-loading for heavy tools (rbenv, gcloud).
-   **Modern Stack**: 
    -   **Shell**: Zsh + Oh My Zsh
    -   **Editor**: [Neovim](https://github.com/Bigyohann/nvim-config) (Synced as an external repo)
    -   **Multiplexer**: Tmux
    -   **Terminal**: Alacritty / Kitty / WezTerm
    -   **Window Manager**: Aerospace

---

## 🛠️ Installation

```zsh
# Install chezmoi
brew install chezmoi

# Initialize and apply
chezmoi init --apply Bigyohann
```

## ⚙️ Configuration Variables

This setup relies on a local `~/.config/chezmoi/chezmoi.toml` file to store machine-specific data:

```toml
[data]
    work_email = "..."
    personal_email = "..."
    company_name = "..."
    company_dir = "..."
    company_dirs = ["Dir1", "Dir2"] # List of work directories
    personal_dir = "..."
```

---

## ⌨️ Custom Aliases

| Alias | Description |
| :--- | :--- |
| `json` | Format JSON from file or pipe using `jq` |
| `dcpl` | Follow Docker Compose logs |
| `zopt` | Compile and optimize Zsh startup |
| `myaliases` | Display a beautiful reminder of all custom shortcuts |
| `gs` | Git status |
| `gl` | Beautiful, graphical git log |
| `ll` | Detailed, human-readable file listing |

---

## 📁 Repository Structure

-   `dot_zshrc.tmpl`: Main shell config with dynamic pathing and lazy-loading.
-   `dot_gitconfig.tmpl`: Master Git config with identity-switching logic.
-   `run_once_after_generate_ssh_keys.sh.tmpl`: Automated SSH key generation script.
-   `private_work/`: Company-specific configurations.
-   `private_perso/`: Personal configurations and documents.
-   `private_dot_config/`:
    -   `home-manager/`: Nix package declarations (`home.nix`).
    -   `nvim/`: Managed via `.chezmoiexternal.toml`.
    -   `aerospace/`, `alacritty/`, `kitty/`, `wezterm/`: App configurations.
-   `private_dot_local/bin/`:
    -   `executable_optimize_zsh.sh`: Zsh compilation and optimization script.

---
Built with ❤️ by [Bigyohann](https://github.com/Bigyohann)
