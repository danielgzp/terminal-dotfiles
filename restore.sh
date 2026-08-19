#!/usr/bin/env bash
# ==============================================================================
# Script de Restauración e Instalación Idempotente de Dotfiles
# Compatible con Linux (Ubuntu, Debian, Fedora, Arch) y macOS
# ==============================================================================

set -e

# Colores para salida de terminal
GREEN='\033[032m'
BLUE='\033[034m'
YELLOW='\033[1;33m'
RED='\033[031m'
NC='\033[0m' # No Color

log_info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[✓]${NC} $1"; }
log_warn()    { echo -e "${YELLOW}[!]${NC} $1"; }
log_error()   { echo -e "${RED}[✗]${NC} $1"; }

AUTO_YES=false
for arg in "$@"; do
    case $arg in
        -y|--yes)
            AUTO_YES=true
            shift
            ;;
        -h|--help)
            echo "Uso: ./restore.sh [OPCIONES]"
            echo ""
            echo "Opciones:"
            echo "  -y, --yes    Instala dependencias y fuentes automáticamente sin preguntar"
            echo "  -h, --help   Muestra esta ayuda"
            exit 0
            ;;
    esac
done

ask_confirmation() {
    local prompt="$1"
    if [ "$AUTO_YES" = true ]; then
        return 0
    fi
    read -rp "$prompt [S/n]: " response
    case "${response,,}" in
        n|no) return 1 ;;
        *) return 0 ;;
    esac
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$SCRIPT_DIR/dotfiles"

echo "======================================================="
echo "   🚀 Iniciando Restauración y Configuración de Terminal"
echo "======================================================="

# ------------------------------------------------------------------------------
# 1. Detección de Sistema Operativo y Gestor de Paquetes
# ------------------------------------------------------------------------------
PKG_MANAGER=""
if command -v apt-get &> /dev/null; then
    PKG_MANAGER="apt"
elif command -v dnf &> /dev/null; then
    PKG_MANAGER="dnf"
elif command -v pacman &> /dev/null; then
    PKG_MANAGER="pacman"
elif command -v brew &> /dev/null; then
    PKG_MANAGER="brew"
fi

# ------------------------------------------------------------------------------
# 2. Verificación e Instalación de Dependencias del Sistema
# ------------------------------------------------------------------------------
MISSING_TOOLS=()

for tool in zsh git curl tar; do
    if ! command -v "$tool" &> /dev/null; then
        MISSING_TOOLS+=("$tool")
    fi
done

for tool in eza zoxide fzf; do
    if ! command -v "$tool" &> /dev/null; then
        MISSING_TOOLS+=("$tool")
    fi
done

if [ ${#MISSING_TOOLS[@]} -gt 0 ]; then
    log_warn "Herramientas faltantes detectadas: ${MISSING_TOOLS[*]}"
    
    if [ -n "$PKG_MANAGER" ]; then
        if ask_confirmation "¿Deseas intentar instalar las herramientas faltantes con $PKG_MANAGER?"; then
            log_info "Instalando paquetes..."
            case $PKG_MANAGER in
                apt)
                    sudo apt-get update
                    for t in "${MISSING_TOOLS[@]}"; do
                        case $t in
                            eza)
                                # Intentar apt directo o añadir repo oficial gierens si no existe en la distro
                                sudo apt-get install -y eza 2>/dev/null || {
                                    log_warn "eza no disponible en repo estándar. Instalando vía keyring oficial..."
                                    sudo mkdir -p /etc/apt/keyrings
                                    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg 2>/dev/null || true
                                    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list >/dev/null
                                    sudo apt-get update && sudo apt-get install -y eza || log_warn "No se pudo instalar eza automáticamente."
                                }
                                ;;
                            *)
                                sudo apt-get install -y "$t" 2>/dev/null || log_warn "No se pudo instalar $t con apt."
                                ;;
                        esac
                    done
                    ;;
                dnf)
                    sudo dnf install -y "${MISSING_TOOLS[@]}" || log_warn "Algunos paquetes no se pudieron instalar con dnf."
                    ;;
                pacman)
                    sudo pacman -S --noconfirm "${MISSING_TOOLS[@]}" || log_warn "Algunos paquetes no se pudieron instalar con pacman."
                    ;;
                brew)
                    brew install "${MISSING_TOOLS[@]}" || log_warn "Algunos paquetes no se pudieron instalar con brew."
                    ;;
            esac
        fi
    else
        log_warn "No se detectó un gestor de paquetes soportado (apt, dnf, pacman, brew). Instala manualmente: ${MISSING_TOOLS[*]}"
    fi
else
    log_success "Todas las herramientas esenciales (zsh, git, curl, eza, zoxide, fzf) están instaladas."
fi

# ------------------------------------------------------------------------------
# 3. Instalación de Fuentes Nerd Font (MesloLGS NF)
# ------------------------------------------------------------------------------
install_fonts() {
    local FONT_DIR
    if [[ "$OSTYPE" == "darwin"* ]]; then
        FONT_DIR="$HOME/Library/Fonts"
    else
        FONT_DIR="$HOME/.local/share/fonts"
    fi

    mkdir -p "$FONT_DIR"

    # Verificar si ya existen las fuentes
    if [ -f "$FONT_DIR/MesloLGS NF Regular.ttf" ]; then
        log_success "Fuentes MesloLGS NF ya están instaladas."
        return 0
    fi

    if ask_confirmation "¿Deseas descargar e instalar automáticamente las fuentes MesloLGS NF (Nerd Font)?"; then
        log_info "Descargando tipografía MesloLGS NF..."
        local BASE_URL="https://github.com/romkatv/powerlevel10k-media/raw/master"
        curl -fsSL "$BASE_URL/MesloLGS%20NF%20Regular.ttf" -o "$FONT_DIR/MesloLGS NF Regular.ttf"
        curl -fsSL "$BASE_URL/MesloLGS%20NF%20Bold.ttf" -o "$FONT_DIR/MesloLGS NF Bold.ttf"
        curl -fsSL "$BASE_URL/MesloLGS%20NF%20Italic.ttf" -o "$FONT_DIR/MesloLGS NF Italic.ttf"
        curl -fsSL "$BASE_URL/MesloLGS%20NF%20Bold%20Italic.ttf" -o "$FONT_DIR/MesloLGS NF Bold Italic.ttf"

        if command -v fc-cache &> /dev/null; then
            fc-cache -f "$FONT_DIR" > /dev/null 2>&1
        fi
        log_success "Fuentes MesloLGS NF instaladas correctamente en $FONT_DIR."
    fi
}

install_fonts

# ------------------------------------------------------------------------------
# 4. Asegurar Directorios Base
# ------------------------------------------------------------------------------
mkdir -p "$HOME/.config/ghostty"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/share"

# ------------------------------------------------------------------------------
# 5. Instalación Idempotente de Oh My Zsh
# ------------------------------------------------------------------------------
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    log_info "Instalando Oh My Zsh..."
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    log_success "Oh My Zsh instalado."
else
    log_success "Oh My Zsh ya está instalado."
fi

# ------------------------------------------------------------------------------
# 6. Descarga / Actualización de Plugins y Temas de Oh My Zsh
# ------------------------------------------------------------------------------
OMZ_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

clone_or_update() {
    local repo_url="$1"
    local dest_dir="$2"
    local name="$3"

    if [ -d "$dest_dir/.git" ]; then
        log_info "Actualizando $name..."
        git -C "$dest_dir" pull --quiet --ff-only 2>/dev/null || log_warn "$name ya existe (no se pudo actualizar con git pull, se mantiene la versión actual)."
        log_success "$name listo."
    elif [ -d "$dest_dir" ]; then
        log_success "$name ya está presente en $dest_dir."
    else
        log_info "Clonando $name..."
        git clone --depth=1 "$repo_url" "$dest_dir"
        log_success "$name instalado."
    fi
}

log_info "Verificando plugins y temas de Oh My Zsh..."
clone_or_update "https://github.com/romkatv/powerlevel10k.git" "$OMZ_CUSTOM/themes/powerlevel10k" "Tema Powerlevel10k"
clone_or_update "https://github.com/zsh-users/zsh-autosuggestions" "$OMZ_CUSTOM/plugins/zsh-autosuggestions" "Plugin zsh-autosuggestions"
clone_or_update "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$OMZ_CUSTOM/plugins/zsh-syntax-highlighting" "Plugin zsh-syntax-highlighting"
clone_or_update "https://github.com/Aloxaf/fzf-tab" "$OMZ_CUSTOM/plugins/fzf-tab" "Plugin fzf-tab"

# ------------------------------------------------------------------------------
# 7. Restauración Segura de Archivos de Configuración (con Backup Timestamp)
# ------------------------------------------------------------------------------
safe_copy_config() {
    local src="$1"
    local dest="$2"
    local label="$3"

    if [ -f "$src" ]; then
        if [ -f "$dest" ]; then
            if cmp -s "$src" "$dest"; then
                log_success "$label ya está al día."
                return 0
            fi
            local backup_name="${dest}.bak_$(date +%Y%m%d_%H%M%S)"
            cp "$dest" "$backup_name"
            log_info "Respaldo creado: $backup_name"
        fi
        mkdir -p "$(dirname "$dest")"
        cp "$src" "$dest"
        log_success "$label restaurado."
    fi
}

log_info "Restaurando archivos de configuración..."
safe_copy_config "$DOTFILES_DIR/ghostty/config" "$HOME/.config/ghostty/config" "Configuración de Ghostty (config)"
safe_copy_config "$DOTFILES_DIR/ghostty/config.ghostty" "$HOME/.config/ghostty/config.ghostty" "Configuración de Ghostty (config.ghostty)"
safe_copy_config "$DOTFILES_DIR/zshrc" "$HOME/.zshrc" "Configuración de Zsh (.zshrc)"
safe_copy_config "$DOTFILES_DIR/p10k.zsh" "$HOME/.p10k.zsh" "Configuración de Powerlevel10k (.p10k.zsh)"

# ------------------------------------------------------------------------------
# 8. Comprobación de Shell por Defecto
# ------------------------------------------------------------------------------
CURRENT_SHELL="$(basename "$SHELL")"
if [ "$CURRENT_SHELL" != "zsh" ] && command -v zsh &> /dev/null; then
    ZSH_PATH="$(which zsh)"
    if ask_confirmation "Zsh no es tu shell por defecto actualmente. ¿Deseas configurarlo ahora?"; then
        log_info "Cambiando shell por defecto a $ZSH_PATH..."
        chsh -s "$ZSH_PATH" || log_warn "No se pudo cambiar automáticamente con chsh. Ejecuta manualmente: chsh -s $(which zsh)"
    fi
fi

# ------------------------------------------------------------------------------
# 9. Resumen Final
# ------------------------------------------------------------------------------
echo ""
echo "======================================================="
echo -e "${GREEN}🎉 ¡Restauración y configuración completada con éxito!${NC}"
echo "======================================================="
echo "Para comenzar a usar tu nueva configuración:"
echo "  1. Si estás en una sesión activa de terminal: ejecuta 'source ~/.zshrc' o 'exec zsh'"
echo "  2. Si instalaste fuentes o cambiaste de shell: reinicia tu emulador de terminal (Ghostty)"
echo ""
