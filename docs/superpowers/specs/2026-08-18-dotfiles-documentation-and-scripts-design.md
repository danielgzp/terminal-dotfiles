# Diseño Técnico: Documentación Exhaustiva y Optimización Idempotente de Dotfiles

## 1. Contexto y Objetivos

El repositorio `terminal-dotfiles` contiene la configuración de entorno de terminal basada en **Ghostty**, **Zsh**, **Oh My Zsh**, **Powerlevel10k** y herramientas CLI modernas (`eza`, `zoxide`, `fzf`, `fnm`).

### Objetivos:
1. **Idempotencia y Resiliencia**: Permitir que `restore.sh` se ejecute repetidamente o sobre instalaciones a medio configurar sin lanzar errores de Git o sobreescribir destructivamente respaldos anteriores.
2. **Portabilidad**: Eliminar rutas fijas vinculadas a nombres de usuario locales (`/home/danieldev`) y agregar validaciones de existencia para Homebrew y otras herramientas.
3. **Instalación Asistida de Dependencias y Fuentes**: Detección de distribuciones (Ubuntu/Debian, Fedora, Arch, macOS) para ofrecer instalación automática de paquetes CLI faltantes y descarga de la tipografía Nerd Font `MesloLGS NF`.
4. **Documentación Exhaustiva**: Crear un `README.md` completo con guías paso a paso, manuales de instalación por sistema operativo, catálogo de alias/herramientas y sección de solución de problemas (FAQ).

---

## 2. Cambios en Scripts

### 2.1. `restore.sh`
- **Manejo de Errores e Idempotencia**:
  - Validar si `git`, `curl` y `tar` existen. Si no, avisar al usuario.
  - Para plugins de Oh My Zsh (`powerlevel10k`, `zsh-autosuggestions`, `zsh-syntax-highlighting`, `fzf-tab`), verificar si el directorio ya existe:
    - Si existe: ejecutar `git -C <dir> pull --quiet` o saltar sin arrojar error `fatal: destination path already exists`.
    - Si no existe: clonar con `git clone`.
  - Para Oh My Zsh: comprobar si `~/.oh-my-zsh` existe antes de intentar la instalación desatendida.
- **Respaldos Seguros con Marca de Tiempo**:
  - Antes de sobreescribir `~/.zshrc`, `~/.p10k.zsh` o `~/.config/ghostty/config`, generar un respaldo con formato `~/.<archivo>.bak_$(date +%Y%m%d_%H%M%S)`.
- **Detección e Instalación Opcional de Paquetes**:
  - Detectar el gestor de paquetes (`apt`, `dnf`, `pacman`, `brew`).
  - Identificar herramientas faltantes (`eza`, `zoxide`, `fzf`, `fnm`, `zsh`).
  - Preguntar de forma interactiva (o vía bandera `--yes` / `-y`) si el usuario desea instalarlas automáticamente.
- **Aprovisionamiento de Fuentes (`MesloLGS NF`)**:
  - Si la fuente `MesloLGS NF` no está en el sistema, ofrecer descargar los 4 archivos `.ttf` (Regular, Bold, Italic, Bold Italic) desde el repositorio oficial de GitHub de romkatv/powerlevel10k-media a `~/.local/share/fonts/` (Linux) o `~/Library/Fonts/` (macOS), seguido de `fc-cache -f`.
- **Configuración de Shell**:
  - Ofrecer configurar Zsh como shell por defecto mediante `chsh -s $(which zsh)`.

### 2.2. `backup.sh`
- Copiar de forma segura las configuraciones actuales del usuario (`~/.zshrc`, `~/.p10k.zsh`, `~/.config/ghostty/config`, `~/.config/ghostty/config.ghostty`) hacia `dotfiles/`.
- Empaquetar `terminal_backup.tar.gz` conteniendo `dotfiles/`, `restore.sh` y `README.md`.

---

## 3. Correcciones de Configuración (`dotfiles/zshrc`)

1. **Ruta Portable de `fnm`**:
   - Reemplazar `FNM_PATH="/home/danieldev/.local/share/fnm"` por `FNM_PATH="$HOME/.local/share/fnm"`.
2. **Carga Condicional de Homebrew**:
   - Verificar la existencia de binarios en `/home/linuxbrew/.linuxbrew/bin/brew` y `/opt/homebrew/bin/brew` antes de invocar `eval`.
3. **Activación de Powerlevel10k**:
   - Configurar `ZSH_THEME="powerlevel10k/powerlevel10k"`.
   - Incluir la carga condicional de `[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh` al inicio de `.zshrc`.

---

## 4. Estructura de Documentación (`README.md`)

1. **Introducción & Stack**: Descripción de Ghostty, Zsh, Oh My Zsh, Powerlevel10k, eza, zoxide, fzf, fnm.
2. **Inicio Rápido**:
   - Clonar repositorio o extraer `.tar.gz`.
   - Ejecutar `./restore.sh`.
3. **Instalación Manual de Dependencias por SO**:
   - Ubuntu / Debian (`apt`, repositorios de eza, zoxide).
   - Fedora (`dnf`).
   - Arch Linux (`pacman`).
   - macOS (`brew`).
4. **Instalación Manual de Fuentes**:
   - Enlaces y comandos de terminal para instalar las 4 variantes de `MesloLGS NF`.
5. **Catálogo de Atajos y Alias**:
   - Navegación (`..`, `...`, `....`, `cd` con zoxide).
   - Explorador de archivos (`ls`, `ll`, `la`, `lt` con eza).
   - Git (`g`, `gs`, `gd`, `gl`, `gp`, `gco`, `gc`, `gca`).
   - Utilidades (`pn` para pnpm, `antigravity-ide`, accesos a configuraciones).
6. **Creación de Respaldos**:
   - Uso de `./backup.sh`.
7. **Preguntas Frecuentes y Solución de Problemas**:
   - Iconos rotos / fuentes faltantes.
   - Errores de comandos no encontrados.
   - Cambio de shell no persistente.
