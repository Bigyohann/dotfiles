# ✨ Biggy's Dotfiles 🚀

A modular, private, and highly automated dotfiles configuration managed by [chezmoi](https://www.chezmoi.io/).

## 🌟 Key Features

-   **Privacy First**: Personal emails, company names, and GitLab tokens are hidden using chezmoi templates and local variables.
-   **Dynamic Identities**: Automatically switches Git identities (Email + SSH Keys) based on the directory you are working in.
-   **Pro Aliases**: Custom aliases for JSON formatting (`json`), Docker Compose (`dcpl`), and advanced Git logging (`gl`).
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
    glab_token = "glpat-..."
    glab_user = "..."
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
| `myaliases` | Display a beautiful reminder of all custom shortcuts |
| `gs` | Git status |
| `gl` | Beautiful, graphical git log |
| `ll` | Detailed, human-readable file listing |

---

## 📁 Repository Structure

-   `.zshrc.tmpl`: Main shell config with dynamic pathing.
-   `.gitconfig.tmpl`: Master Git config with identity-switching logic.
-   `scripts/`:
    -   `run_once_after_00-bootstrap.sh.tmpl`: Consolidated script to install Nix, Home Manager, and Neovim from source.
    -   `run_once_before_setup-ssh.sh.tmpl`: SSH key generation script.
-   `private_dot_config/`:
    -   `home-manager/`: Nix package declarations (`home.nix`).
    -   `glab-cli/`: Templated config with hidden secrets.
    -   `nvim/`: Managed via `.chezmoiexternal.toml`.
    -   `aerospace/`, `alacritty/`, `kitty/`, `wezterm/`: App configurations.

---
Built with ❤️ by [Bigyohann](https://github.com/Bigyohann)
