#!/usr/bin/env bash
# Script para respaldar configuraciones de la terminal (Ghostty, Zsh, Aliases)

# Salir si ocurre un error
set -e

BACKUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$BACKUP_DIR/dotfiles"

echo "=== Iniciando respaldo de configuraciones ==="

# Crear carpetas si no existen
mkdir -p "$DOTFILES_DIR/ghostty"

# 1. Copiar configuraciones de Zsh
echo "Copiando configuración de Zsh..."
if [ -f "$HOME/.zshrc" ]; then
    cp "$HOME/.zshrc" "$DOTFILES_DIR/zshrc"
    echo "✓ .zshrc respaldado"
fi

if [ -f "$HOME/.p10k.zsh" ]; then
    cp "$HOME/.p10k.zsh" "$DOTFILES_DIR/p10k.zsh"
    echo "✓ .p10k.zsh respaldado"
fi

# 2. Copiar configuraciones de Ghostty
echo "Copiando configuración de Ghostty..."
if [ -f "$HOME/.config/ghostty/config" ]; then
    cp "$HOME/.config/ghostty/config" "$DOTFILES_DIR/ghostty/config"
    echo "✓ config de Ghostty respaldado"
fi

if [ -f "$HOME/.config/ghostty/config.ghostty" ]; then
    cp "$HOME/.config/ghostty/config.ghostty" "$DOTFILES_DIR/ghostty/config.ghostty"
    echo "✓ config.ghostty de Ghostty respaldado"
fi

# 3. Crear el archivo comprimido portátil
echo "Creando archivo comprimido..."
cd "$BACKUP_DIR"
tar -czf terminal_backup.tar.gz dotfiles/ restore.sh README.md 2>/dev/null || tar -czf terminal_backup.tar.gz dotfiles/ restore.sh

echo "============================================="
echo "✓ ¡Respaldo completado con éxito!"
echo "✓ Archivo creado: $BACKUP_DIR/terminal_backup.tar.gz"
echo "Guarda este archivo (.tar.gz) en tu drive, GitHub o disco externo."
echo "============================================="
