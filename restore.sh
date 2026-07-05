#!/usr/bin/env bash
# Script para restaurar e instalar configuraciones de Zsh, Ghostty y plugins

# Salir si ocurre un error
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$SCRIPT_DIR/dotfiles"

echo "=== Iniciando restauración de configuraciones ==="

# 1. Asegurar la existencia de directorios de configuración
mkdir -p "$HOME/.config/ghostty"
mkdir -p "$HOME/.local/bin"

# 2. Restaurar configuraciones de Ghostty
echo "Restaurando configuraciones de Ghostty..."
if [ -f "$DOTFILES_DIR/ghostty/config" ]; then
    if [ -f "$HOME/.config/ghostty/config" ]; then
        cp "$HOME/.config/ghostty/config" "$HOME/.config/ghostty/config.old"
        echo "  - Respaldada config de Ghostty actual como config.old"
    fi
    cp "$DOTFILES_DIR/ghostty/config" "$HOME/.config/ghostty/config"
    echo "✓ config de Ghostty restaurado"
fi

if [ -f "$DOTFILES_DIR/ghostty/config.ghostty" ]; then
    if [ -f "$HOME/.config/ghostty/config.ghostty" ]; then
        cp "$HOME/.config/ghostty/config.ghostty" "$HOME/.config/ghostty/config.ghostty.old"
        echo "  - Respaldada config.ghostty actual como config.ghostty.old"
    fi
    cp "$DOTFILES_DIR/ghostty/config.ghostty" "$HOME/.config/ghostty/config.ghostty"
    echo "✓ config.ghostty de Ghostty restaurado"
fi

# 3. Instalar Oh My Zsh si no existe
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh My Zsh no encontrado. Instalando..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo "✓ Oh My Zsh instalado"
else
    echo "✓ Oh My Zsh ya está instalado"
fi

# 4. Descargar plugins y temas faltantes de Oh My Zsh
OMZ_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

echo "Verificando plugins y temas de Oh My Zsh..."

# powerlevel10k
if [ ! -d "$OMZ_CUSTOM/themes/powerlevel10k" ]; then
    echo "Instalando tema powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$OMZ_CUSTOM/themes/powerlevel10k"
fi

# zsh-autosuggestions
if [ ! -d "$OMZ_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "Instalando plugin zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$OMZ_CUSTOM/plugins/zsh-autosuggestions"
fi

# zsh-syntax-highlighting
if [ ! -d "$OMZ_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "Instalando plugin zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$OMZ_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# fzf-tab
if [ ! -d "$OMZ_CUSTOM/plugins/fzf-tab" ]; then
    echo "Instalando plugin fzf-tab..."
    git clone https://github.com/Aloxaf/fzf-tab "$OMZ_CUSTOM/plugins/fzf-tab"
fi

echo "✓ Plugins y temas verificados e instalados"

# 5. Restaurar archivos de configuración de Zsh
echo "Restaurando archivos de configuración de Zsh..."
if [ -f "$DOTFILES_DIR/zshrc" ]; then
    if [ -f "$HOME/.zshrc" ]; then
        cp "$HOME/.zshrc" "$HOME/.zshrc.old"
        echo "  - Respaldado .zshrc actual como .zshrc.old"
    fi
    cp "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"
    echo "✓ .zshrc restaurado"
fi

if [ -f "$DOTFILES_DIR/p10k.zsh" ]; then
    if [ -f "$HOME/.p10k.zsh" ]; then
        cp "$HOME/.p10k.zsh" "$HOME/.p10k.zsh.old"
        echo "  - Respaldado .p10k.zsh actual como .p10k.zsh.old"
    fi
    cp "$DOTFILES_DIR/p10k.zsh" "$HOME/.p10k.zsh"
    echo "✓ .p10k.zsh restaurado"
fi

echo "============================================="
echo "✓ ¡Restauración completada con éxito!"
echo ""
echo "Nota: Para completar la experiencia, asegúrate de instalar las herramientas del sistema:"
echo "  - eza: Reemplazo para 'ls' con iconos (ej: 'brew install eza' o 'sudo apt install eza')"
echo "  - zoxide: Navegación inteligente (ej: 'brew install zoxide' o 'sudo apt install zoxide')"
echo "  - fzf: Buscador difuso (ej: 'brew install fzf')"
echo ""
echo "Por favor, reinicia la terminal o ejecuta 'source ~/.zshrc' para aplicar todo."
echo "============================================="
