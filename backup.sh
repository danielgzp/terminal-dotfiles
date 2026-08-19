#!/usr/bin/env bash
# ==============================================================================
# Script de Respaldo de Configuraciones de Terminal (Ghostty, Zsh, Aliases)
# ==============================================================================

set -e

# Colores
GREEN='\033[032m'
BLUE='\033[034m'
YELLOW='\033[1;33m'
RED='\033[031m'
NC='\033[0m'

log_info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[✓]${NC} $1"; }
log_warn()    { echo -e "${YELLOW}[!]${NC} $1"; }
log_error()   { echo -e "${RED}[✗]${NC} $1"; }

BACKUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$BACKUP_DIR/dotfiles"

echo "======================================================="
echo "   📦 Iniciando Respaldo de Configuraciones Locales"
echo "======================================================="

# Crear carpetas de destino si no existen
mkdir -p "$DOTFILES_DIR/ghostty"

# 1. Copiar configuraciones de Zsh
log_info "Respaldando archivos de Zsh..."
if [ -f "$HOME/.zshrc" ]; then
    cp "$HOME/.zshrc" "$DOTFILES_DIR/zshrc"
    log_success ".zshrc respaldado"
else
    log_warn "No se encontró ~/.zshrc en tu sistema"
fi

if [ -f "$HOME/.p10k.zsh" ]; then
    cp "$HOME/.p10k.zsh" "$DOTFILES_DIR/p10k.zsh"
    log_success ".p10k.zsh respaldado"
else
    log_warn "No se encontró ~/.p10k.zsh en tu sistema"
fi

# 2. Copiar configuraciones de Ghostty
log_info "Respaldando archivos de Ghostty..."
if [ -f "$HOME/.config/ghostty/config" ]; then
    cp "$HOME/.config/ghostty/config" "$DOTFILES_DIR/ghostty/config"
    log_success "config de Ghostty respaldado"
fi

if [ -f "$HOME/.config/ghostty/config.ghostty" ]; then
    cp "$HOME/.config/ghostty/config.ghostty" "$DOTFILES_DIR/ghostty/config.ghostty"
    log_success "config.ghostty de Ghostty respaldado"
fi

# 3. Crear archivo comprimido portable
log_info "Empaquetando archivo comprimido portable..."
cd "$BACKUP_DIR"

tar -czf terminal_backup.tar.gz \
    dotfiles/ \
    restore.sh \
    backup.sh \
    README.md 2>/dev/null || tar -czf terminal_backup.tar.gz dotfiles/ restore.sh README.md

echo ""
echo "======================================================="
echo -e "${GREEN}🎉 ¡Respaldo completado con éxito!${NC}"
echo "Archivo generado: $BACKUP_DIR/terminal_backup.tar.gz"
echo "Puedes sincronizar este repositorio con Git o llevarte el .tar.gz a otra PC."
echo "======================================================="
